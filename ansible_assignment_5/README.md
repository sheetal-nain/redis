#  Ansible role
An Ansible Role is a way to organize and reuse automation code in Ansible playbooks. Roles allow you to structure your playbooks in a modular way, making it easier to manage and maintain large automation tasks.

A role mainly contains multiple components, such as tasks, variables, files, templates, and handlers, all organized into predefined directory structures.

 #  Run  commands based on the following conditions:
## 1. To execute the playbook.
- Run the following  command

   - ``` ansible-playbook -i inventory.ini redis_playbook.yml -e "redis_version=6.2.6" ```

![ansible_assignment_5](pictures/tool_pb_1.png)
![ansible_assignment_5](pictures/tool_pb_2.png)



## 2. Then go to the node server, to check the redis version.
- Run the following  command

   - ``` redis-cli -v ```

![ansible_assignment_5](pictures/tool_result.png)
