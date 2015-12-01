var fs = require('fs');

var cfg = {
    ssl: true,
    port: 9010,
    ssl_key: 'codebender-localhost.key',
    ssl_cert: 'localhost_codebender_cc.crt'
};

var httpServ = require('https');
var WebSocketServer = require('ws').Server;
var app = null;

// dummy request processing
var processRequest = function (req, res) {
    res.writeHead(200);
    res.end("All glory to WebSockets!\n");
};

app = httpServ.createServer({
    key: fs.readFileSync(cfg.ssl_key),
    cert: fs.readFileSync(cfg.ssl_cert)
}, processRequest).listen(cfg.port);

var wss = new WebSocketServer({ server: app });
console.log('New server created, waiting for connections.');

wss.on('connection', function (wsConnect) {

    var responded = false;
    var counter = 0;

    wsConnect.send('installation started');

    function startEventListeners() {
        wsConnect.on('message', function (message) {
            console.log('Received message: %s', message);
            if (message == 'installation complete ack' || message == 'installation failed ack') {
                responded = true;
                wsConnect.send('ack ack', {}, function () {
                   console.log('Server sent ack ack to the browser.');
                   fs.writeFileSync('results.txt', 'done', 'utf8');
                   process.exit();
                });
            }
        });
    }

    function Success() {
        if (!responded) {
            if (counter < 60) {
                console.log('Inside function Success, waiting for browser to respond');
                wsConnect.send('installation complete');
                counter++;
                setTimeout(Success, 1000);
                return;
            }
            process.exit();
        }
    }

    function Failure(data) {
        if (!responded) {
            if (counter < 60) {
                console.log('Inside function Failure, waiting for browser to respond');
                wsConnect.send('installation failure ' + data);
                counter++;
                setTimeout(Failure.bind(this, data), 1000);
                return;
            }
            process.exit();
        }
    }

    function loop() {
        console.log('Check if install.txt exists.');

        if (!fs.existsSync('install.txt')) {
            console.log('File install.txt does not exist');
            setTimeout(loop, 1000);
            return;
        }

        var data = fs.readFileSync('install.txt', 'utf8');
        console.log('Data of install.txt: ' + data);

        if (data.search('success') != -1) {
            console.log(data);
            Success();
            startEventListeners();
            return;
        }

        if (data.search('failure') != -1) {
            console.log(data);
            Failure(data);
            startEventListeners();
            return;
        }

        setTimeout(loop, 1000);
        return;
    }
    loop();
});
