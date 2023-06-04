# This is a multistep file. The "as" keyword defines the job
#--------- builder job -----------
FROM node:alpine as build-step
USER node
RUN mkdir -p /home/node/app
WORKDIR /home/node/app
COPY --chown=node:node package.json .
RUN npm install
#Teeechnically this copy cmd is replaced by the volume, but this is still useful if ever we make the call without docker-compose
COPY --chown=node:node . .
RUN npm run build 

#--------- nginx job -----------
FROM nginx
#nginx requires us to assign things here. 
COPY --from=build-step /home/node/app/build /usr/share/nginx/html
#nginx base image has a default start command to start the nginx server. 