#  Ansible modules
Ansible modules are small programs that define how and when to perform automation tasks on a remote host or local machine.They are also known as "task plugins" or "library plugins".


 #  Run  commands based on the following conditions:
## 1. To establish connection with the node server.
- Run the following  command

   - ``` ssh ubuntu@<IP> ```

![ansible_assi_1](pictures/ansible_connection.png)



## 2. To add team ninja.
- Run the following  command

   - ``` ansible all -m group -a "name=ninja" -b ```

![ansible_assi_1](pictures/add_team.png)
![ansible_assi_1](pictures/add_team..png)



## 3. To add user Nitish in team ninja.
- Run the following  command

   - ``` ansible all -m user -a "name=Nitish group=ninja" -b ```

![ansible_assi_1](pictures/add_user.png)
![ansible_assi_1](pictures/add_user..png)



## 4. A user should have read,write, execute access to home directory.
- Run the following  command

   - ``` ansible all -m file -a "dest=/home/Nitish mode=751 owner=Nitish group=ninja" -b ```

![ansible_assi_1](pictures/home_dir_per.png)



## 5. In home directory of every user there should be 2 shared directories.
- Run the following  command

   - ``` ansible all -m file -a "dest=/home/Nitish/TEAM state=directory” -b ```
   - ``` ansible all -m file -a "dest=/home/Nitish/TEAM state=directory” -b ```

![ansible_assi_1](pictures/add_dir.png)



## 6. Team: The same team members will have full access.
- Run the following  command

   - ``` ansible all -m file -a "path=/home/Nitish/TEAM group=group_name owner=Nitish" -b ```
 


## 7. Ninja: All ninja's will have full access.
- Run the following  command

   - ``` ansible all -m file -a "path=/home/Nitish/NINJA group=common_group owner=Nitish" -b ```

![ansible_assi_1](pictures/change_grp.png)
![ansible_assi_1](pictures/chnage_grp..png)



## 8. Change user Shell.
- Run the following  command

   - ``` ansible all -m user -a "name=Nitish shell=/bin/bash" -b ```

![ansible_assi_1](pictures/shell_chng.png)
![ansible_assi_1](pictures/shell_chng..png)


## 9. Change user password.
- Run the following  command

   - ``` ansible all -m user -a "name=Nitish update_password=always password={{ newpassword|password_hash('sha512') }}" -b --extra-vars "newpassword=1234" ```

![ansible_assi_1](pictures/pass_chng.png)


## 10. Delete user.
- Run the following  command

   - ``` ansible all -m user -a "name=alpha state=absent" -b ```

![ansible_assi_1](pictures/del_usr.png)
![ansible_assi_1](pictures/del_usr..png)


## 11. Delete Group.
- Run the following  command

   - ``` ansible all -m group -a "name=gamma state=absent" -b ```

![ansible_assi_1](pictures/del_grp.png)
![ansible_assi_1](pictures/del_grp..png)


## 12. List user or Team.
- Run the following  command

   - ``` ansible all -m command -a "getent group" -u ubuntu@ip-172-31-7-125 -b ```


   - ``` ansible all -m command -a "getent passwd" -u ubuntu@ip-172-31-7-125 -b ```
  











