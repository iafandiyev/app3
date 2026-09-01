const express = require('express');
const { WebSocketServer } = require('ws');
const http = require('http');

const app = express();
const server = http.createServer(app);
const wss = new WebSocketServer({ server });

let players = {};
let food = [];
let viruses = [];

const MAP_SIZE = 6000;
const MAX_FOOD = 500;
const MAX_VIRUSES = 30;

function spawnFood() {
    while (food.length < MAX_FOOD) {
        food.push({
            id: Math.random().toString(36).substring(2, 9),
            x: Math.random() * MAP_SIZE - MAP_SIZE/2,
            y: Math.random() * MAP_SIZE - MAP_SIZE/2,
            color: Math.floor(Math.random() * 6)
        });
    }
}

function spawnViruses() {
    while (viruses.length < MAX_VIRUSES) {
        viruses.push({
            id: Math.random().toString(36).substring(2, 9),
            x: Math.random() * MAP_SIZE - MAP_SIZE/2,
            y: Math.random() * MAP_SIZE - MAP_SIZE/2
        });
    }
}

spawnFood();
spawnViruses();

wss.on('connection', (ws) => {
    let playerId = Math.random().toString(36).substring(2, 9);
    console.log(`Player connected: ${playerId}`);
    
    // Initial state sent to the new player
    ws.send(JSON.stringify({
        type: 'init',
        id: playerId,
        food: food,
        viruses: viruses,
        players: players
    }));
    
    ws.on('message', (message) => {
        try {
            const data = JSON.parse(message);
            if (data.type === 'join') {
                players[playerId] = {
                    id: playerId,
                    name: data.name,
                    cells: [{
                        x: Math.random() * 1000 - 500,
                        y: Math.random() * 1000 - 500,
                        mass: 20
                    }],
                    color: Math.floor(Math.random() * 6)
                };
            } else if (data.type === 'update') {
                if (players[playerId]) {
                    players[playerId].cells = data.cells; // Client sends its cells positions/mass
                }
            } else if (data.type === 'eatFood') {
                food = food.filter(f => f.id !== data.id);
                // spawn new food slowly
                if (Math.random() < 0.5) spawnFood();
            } else if (data.type === 'eatPlayer') {
                if (players[data.targetId]) {
                    // Send death event to that player or just remove them
                    // Since it's client authority, we just relay
                    // But we don't have direct way to notify just them unless we broadcast
                }
            } else if (data.type === 'eject') {
                // Client ejects mass, spawn a special food item
                food.push({
                    id: Math.random().toString(36).substring(2, 9),
                    x: data.x,
                    y: data.y,
                    color: data.color,
                    isEjected: true
                });
            }
        } catch (e) {
            console.error(e);
        }
    });
    
    ws.on('close', () => {
        console.log(`Player disconnected: ${playerId}`);
        delete players[playerId];
    });
});

// Broadcast game state to all clients at 30 FPS (33ms)
setInterval(() => {
    const state = JSON.stringify({
        type: 'state',
        players: players,
        food: food,
        viruses: viruses
    });
    wss.clients.forEach(client => {
        if (client.readyState === 1) { // OPEN
            client.send(state);
        }
    });
}, 33);

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
