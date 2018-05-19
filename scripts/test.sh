#!/bin/bash

# Should be run from project root.
cd core
npm test
cd ..

cd server
mix test