#!/usr/bin/env node

var fs = require("fs");
var eco = require("eco");

var args = process.argv.slice(2);
if (args.length != 2) {
    console.log("Usage: eco.js <source.eco> <destination.js>");
    process.exit();
}

var sourceFilename = args[0];
var destFilename = args[1];
var source = fs.readFileSync(sourceFilename, "utf8");
var compiled = eco.precompile(source);
compiled = "define(function(){return " + compiled + "});";
fs.writeFileSync(destFilename, compiled, "utf8");
