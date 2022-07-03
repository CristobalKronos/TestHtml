const express = require('express');
//const { ReadlineParser } = require('serialport');

const app = express();

const { SerialPort, ReadlineParser } = require('serialport');


const mySerial = new SerialPort({
    path: 'COM6',
    baudRate: 9600
});

/*
SerialPort.list().then(
  ports => ports.forEach(console.log),
  err => console.error(err)
)
*/

const parser = new ReadlineParser({ delimiter: '\r\n' });

mySerial.pipe(parser);

//settings
app.set('port', process.env.PORT || 3000);

//start the server
const server = app.listen(app.get('port'), () => {
    console.log('server on port' , app.get('port'));
})

const socketIO = require('socket.io');

const io = socketIO(server, {
    cors:{
        origin: ['http://localhost:3000']
    }
});

//web sockets
io.on('connection', (socket) => {
    console.log('New Connection');
    socket.on('envio-setpoint', (data) => {
        console.log(data);
        mySerial.write(data);
    });
});

io.on("connect_error", (err) => {
    console.log(`connect_error due to ${err.message}`);
});


mySerial.on('open', function(){
    console.log("Puerto conectado");
});

parser.on('data', function(data){
    //console.log(data.toString());
    io.emit('envio_data', {
        value: data.toString()
    });
});    

mySerial.on('err', function(err){
    console.log(err.message);
});