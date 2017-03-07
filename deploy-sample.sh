#!/bin/bash

#********************************************************* {COPYRIGHT-TOP} ***
# Licensed Materials - Property of IBM
# 5725-L30, 5725-Z22
#
# (C) Copyright IBM Corporation 2017, 2016
#
# All Rights Reserved.
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#********************************************************* {COPYRIGHT-END} ***

curl -q -L https://github.com/strongloop/loopback-getting-started/archive/master.zip -o /tmp/loopback-getting-started.zip
unzip /tmp/loopback-getting-started.zip > /dev/null
cd loopback-getting-started-master
cat << EOF > Dockerfile
FROM node:slim
ADD . /app
WORKDIR /app
RUN npm install
CMD npm start
EOF

cat << EOF > testapp.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: testapp-deployment
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: testapp
    spec:
      containers:
      - name: testapp
        image: 127.0.0.1:30000/apps/testapp
        ports:
        - containerPort: 3000
---
kind: Service
apiVersion: v1
metadata:
  name: testapp-service
spec:
  selector:
    app: testapp
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: testapp-ingress
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /testapp
        backend:
          serviceName: testapp-service
          servicePort: 3000
EOF

echo "In directory 'loopback-getting-started-master/'"
echo "Run 'docker build -t 127.0.0.1:30000/apps/testapp .' to build the image"
echo "Run 'docker push 127.0.0.1:30000/apps/testapp' to push the image to the registry"
echo "Run 'kubectl apply -f testapp.yaml' to deploy the application"
