const express = require('express');
const cors = require('cors');
const app = express();

app.use(
    cors({
        origin: "*",
        methods: ['GET', 'POST']
    })
);

app.get('/', (request, response) => {
    response.json(
        { "name":"Edward", "like":"Cisco" }
    );
});

app.listen(35911);