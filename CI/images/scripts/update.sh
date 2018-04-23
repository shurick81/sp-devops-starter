#!/bin/sh -eux

yum -y update;
yum -y install ansible;
reboot;
sleep 60;
