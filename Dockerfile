# using maven we build our artifact, if as (or alias) mentioned indicates multistage dockerfile
FROM maven as build  

# In container anything we do, it goes here only, if it is not there in container, it will create
WORKDIR /app 

#first '.' for PWD of code and second '.' for PWD of container which we already mentioned as /app
COPY . .   

#run the command
RUN mvn install  

#Second stage

FROM openjdk:11.0
WORKDIR /app

#copy form build done in first stage and mvn saves artifacts in target folder and name of file(Uber.jar) we get from POM.xml file  and copy to PWD of container or can mention as '.' also
COPY --from=build /app/target/Uber.jar /app/

EXPOSE 9090

# mention some executable so that container will be running otherwise it will run a task and exits
CMD [ "java","-jar","Uber.jar" ]


