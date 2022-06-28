---
- name: tests
  hosts: app
  become: yes
  gather_facts: yes
  tasks:
    - name: store date output for timezone check
      command: date
      register: tstamp

    - name: Timezone
      debug:
        msg: "Machine timezone is {{ ansible_date_time.tz }}"

    - name: OS
      debug:
        msg: "OS of machine is {{ ansible_os_family }}"


    - name: update if debian
      ansible.builtin.command: apt update -y
      when: ansible_facts['os_family'] == "Debian"


    - name: update if Centos
      ansible.builtin.command: yum check-update
      when: ansible_facts['os_family'] == "Centos"


#    - name:
#      debug:
#        msg: "{{ inventory_hostname }}"

    - name: Check if port 80 is listening
      shell: lsof -i -P -n | grep LISTEN
      register: port_check_80

    - name: confirm port 80 is listening
      assert:
        that: "'*:80 (LISTEN)' in port_check_80.stdout"


    - name: Check if port 3000 is listening
      shell: lsof -i -P -n | grep LISTEN
      register: port_check_3000

    - name: confirm port 80 is listening
      assert:
        that: "'*:3000 (LISTEN)' in port_check_80.stdout"



