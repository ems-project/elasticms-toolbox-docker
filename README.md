# ElasticMS Toolbox ![Continuous Docker Image Build](https://github.com/ems-project/elasticms-toolbox-docker/workflows/Continuous%20Docker%20Image%20Build/badge.svg)

This docker image is not intended to run containers permanently as a webserver or nodeJS server, it should be used to run single commands to execute tasks.  
Some schedulers like Kubernetes or Openshift give the possibility to run tasks at regular intervals like Cronjobs.  This image can be used in this context.  

## Usage

### [certinfo](https://github.com/pete911/certinfo)

```
docker run -it --rm docker.io/elasticms/toolbox:latest certinfo www.google.com:443
```

### [elasticdump](https://github.com/elasticsearch-dump/elasticsearch-dump)

```
docker run -it --rm docker.io/elasticms/toolbox:latest elasticdump --help
```

### [web2elasticms](https://github.com/ems-project/WebToElasticms)

```
docker run -it --rm docker.io/elasticms/toolbox:latest php application.php --help
```