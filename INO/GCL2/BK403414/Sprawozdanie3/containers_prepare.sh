#!/bin/bash

if docker volume ls | grep "wejsciowy"; then
    echo "Kontener wejściowy już istnieje"
else
    echo "Tworzenie kontenera wejściowego"
    docker volume create wejsciowy
fi

if docker volume ls | grep "wyjsciowy"; then
    echo "Kontener wyjściowy już istnieje"
else
    echo "Tworzenie kontenera wyjściowego"
    docker volume create wyjsciowy
fi

if docker volume ls | grep "deployv"; then
    echo "Kontener wdeployv już istnieje"
else
    echo "Tworzenie kontenera deployv"
    docker volume create deployv
fi