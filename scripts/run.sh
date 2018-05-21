#!/bin/bash

# Should be run from project root.
cd core
npm run build
cd ..

cd server
rm -rf _build
mix phoenix.server
cd ..
