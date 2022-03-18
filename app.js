const express = require('express');
const app = express();
const path = require('path');

const router = require('./routes');

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/scripts', express.static(path.join(__dirname, 'node_modules')));

app.use('/', router);

app.listen(3000, () => {
  console.log('The server is running with port 3000');
});
