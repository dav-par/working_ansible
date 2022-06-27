# This playbook will launch and EC2 with specific configuration of VPC-Subnet-region with public IP enabled
---
- hosts: localhost
  connection: local
  gather_facts: False
  become: True
  vars:
    key_name: eng114
    region: eu-west-1
    image:  ami-07b63aa1cfd3bc3a5
    id: "eng114-david-ansible2"
    sec_group: "sg-08548fc7e8e3d2f45"
    subnet_id: "subnet-00e1f05c00494ae69"
# add the following line if ansible by default uses python 2.7
    #ansible_python_interpreter: /usr/bin/python3
  tasks:

    - name: Facts
      block:

      - name: Get instances facts
        ec2_instance_facts:
          aws_access_key: "{{aws_access_key}}"
          aws_secret_key: "{{aws_secret_key}}"
          region: "{{ region }}"
        register: result


    - name: Provisioning EC2 instances
      block:

      - name: Upload public key to AWS
        ec2_key:
          name: "{{ key_name }}"
          key_material: "{{ lookup('file', '~/.ssh/{{ key_name }}.pub') }}"
          region: "{{ region }}"
          aws_access_key: "{{aws_access_key}}"
          aws_secret_key: "{{aws_secret_key}}"


      - name: Provision instance(s)
        ec2:
          aws_access_key: "{{aws_access_key}}"
          aws_secret_key: "{{aws_secret_key}}"
          assign_public_ip: true
          key_name: "{{ key_name }}"
          id: "{{ id }}"
          vpc_subnet_id: "{{ subnet_id }}"
          group_id: "{{ sec_group }}"
          image: "{{ image }}"
          instance_type: t2.micro
          region: "{{ region }}"
          wait: true
          count: 1
          instance_tags:
            Name: eng114-david-db-setup-by-ansible

      tags: ['never', 'create_ec2']
