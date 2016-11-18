#!/usr/bin/node
var mongoose = require('mongoose')
var cli = require('mongodb').MongoClient;
var constr = "mongodb://localhost:27017/courcework2"
//'mongodb://localhost/courcework2'
mongoose.connect(constr)
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {

    //Create schemas and constraints
    var Counter = mongoose.model('Counter', new mongoose.Schema({
        _id: {type: String, unique: true, required: true},
            seq: { type: Number, default: 0 }
    }), 'counters');

    var Manufacturer = mongoose.model('Manufacturer', new mongoose.Schema({
        _id: { type: Number, unique: true, index: true, required: true },
        name: String,
        country_id: Number,
        address: String,
        }),
        'countries'
    );

    var Phones = mongoose.model('Phones', new mongoose.Schema({
        _id: { type: Number, unique: true, index: true, required: true },
        name: { type: String, unique: true },
        }),
        'phones'
    );

    var Country = mongoose.model('Country', new mongoose.Schema({
        _id: { type: Number, unique: true, index: true, required: true },
        name: { type: String, unique: true },
        }),
        'countries'
    );

    /*
    (new Counter({_id:'customerId'})).save( function (err, counter) {
        if (err) console.error(err);
    });

    (new Counter({_id:'orderId'})).save( function (err, counter) {
        if (err) console.error(err);
    });
    */

    var orderSchema = mongoose.Schema({
        _id: { type: Number, unique: true, index: true},
        customer_id: Number,
        manufacturer_id: Number,
        product_id: Number
        });

    orderSchema.pre('save', function(next) {
        var doc = this;
        Counter.findByIdAndUpdate({_id: 'orderId'}, {$inc: { seq: 1} }, function(error, counter)   {
                if(error) return next(error);
                doc._id = counter.seq;
                next();
            });
    });

    var Order = mongoose.model('Order', orderSchema, 'orders');

    var Product = mongoose.model('Product', new mongoose.Schema({
        _id: { type: Number, unique: true, index: true },
        phone_id: Number,
        manufacturer_id: Number,
        }),
        'production'
    );

    var customerSchema = mongoose.Schema({
        _id: { type: Number, unique: true, index: true },
        firstname: String,
        lastname: String,
        middlename: String,
        register_address: String,
        citizenship_country_id: Number,
        });

    customerSchema.pre('save', function(next) {
        var doc = this;
        Counter.findByIdAndUpdate({_id: 'customerId'}, {$inc: { seq: 1} }, function(error, counter)   {
                if(error) return next(error);
                doc._id = counter.seq;
                next();
            });
    });

    var Customer = mongoose.model('Customer', customerSchema, 'customers');

    //Handle user options
    switch (process.argv[2]) {
        case '-c': 
            if (process.argv.length != 10) {
                console.log(process.argv.length);
                console.log("-c manufacturer_id product_id firstname lastname middlename register_address citizenship_country_id");
                process.exit();
            }
            console.log("manufacturer_id: %s, firstname: %s, lastnamer %s, middlename; %s, register_address; %s, citizenship_country_id: %s", process.argv[3], process.argv[4], process.argv[5], process.argv[6], process.argv[7], process.argv[8], process.argv[9]);
            (new Customer({ 
                    firstname: process.argv[5],
                    lastname: process.argv[6],
                    middlename: process.argv[7],
                    register_address: process.argv[8],
                    citizenship_country_id: process.argv[9],
                })).save(
                function (err, hell){
                    if (err) console.error(err);
                    console.log(hell);
                    console.log("\n\n");
                    (new Order({ 
                            customer_id: hell.id,
                            manufacturer_id: process.argv[3],
                            product_id: process.argv[4],
                        })).save(
                        function (err, hell){
                            if (err) console.error(err);
                            console.log(hell);
                        });
                });
            break;
        case '-r':
            if (process.argv.length != 4) {
                console.log("usage: " + process.argv[1] + " -r product_id")
                return;
            }
            var pr = Customer.find({_id: process.argv[3]},
                function (err, product) {
                    if (err) return console.error(err);
                    console.log(product);
                })
            break;
        case '-u':
            if (process.argv.length != 5) {
                console.log("usage: " + process.argv[1] + " -u customer_id firstname")
                process.exit();
            }
            Customer.update({ _id:process.argv[3]}, { $set: { firstname: process.argv[4]}},
                function (err, customer){
                    if (err) console.error(err);
                    console.log(customer);
                });
            break;
        case '-d':
            if (process.argv.length != 4) {
                console.log("usage: " + process.argv[1] + " -d product_id")
                process.exit();
            }
            Order.find({_id: process.argv[3]}, function(err, orders){
                var a = Customer.findByIdAndRemove(orders[0].customer_id, function (err, hell) 
                    { if(err) {console.log(err); console.error(err);} console.log('success')});
            });
            Order.findByIdAndRemove(process.argv[3]);
            break;
        default:
            console.log('invalid argument')
            console.log('usage: [ -c | -r | -u | -d ]')
            break;
    }
    //process.exit();
});

// Connect to the db
/*
cli.connect(constr, function(err, db) {
    if(err) {
            console.log("hell, " + err);
            return;
    }
    console.log("Connected to courcework2");
    var collection = db.collection('orders');
    var obj = collection.find({ '_id':'1'});
    var stream = collection.find ( { _id:'1'}).stream();
    stream.on('data', function(item) { console.log(item.customer_id)});
    stream.on('end', function() {});
});
*/
