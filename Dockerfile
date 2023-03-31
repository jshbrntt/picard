FROM node:18.15.0-alpine AS base

USER node

ARG WORKING_DIRECTORY

WORKDIR ${WORKING_DIRECTORY}

COPY . .
