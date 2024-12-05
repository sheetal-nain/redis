#!/user/bin/sudo bash
set -x

action=$1

case ${action} in

#To create a group.

addTeam)
                GROUP_NAME=$2	
		LOGFILE="/var/log/group.log"
                cat /etc/group | grep ${GROUP_NAME} >/dev/null 2>&1
if [ $? -eq 0 ] ; then
                echo "group Exists"
else
                echo "group Not Found"
                groupadd ${GROUP_NAME}
if [ $? -eq 0 ]; then
                echo "Group $GROUP_NAME created successfully" >> $LOGFILE
else
                echo "Failed to create group"
fi
fi
;;

#To create a user.

addUser)
              USER_NAME=$2
	      GROUP_NAME=$3
	      LOGFILE="/var/log/user.log"
	      cat /etc/passwd | grep ${USER_NAME} >/dev/null 2>&1
if [ $? -eq 0 ] ; then
                echo "user Exists"
else
                echo "user Not Found"
                useradd -m -G ${GROUP_NAME,shared_group} ${USER_NAME}  
if [ $? -eq 0 ]; then
                echo "user $USER_NAME created successfully" >> $LOGFILE
else
                echo "Failed to create user"
fi
fi

# To set permissions to home directory.
                   chmod 751 /home/$USER_NAME

#- To create shared directory in users home directory.
                   mkdir -p  /home/$USER_NAME/team /home/$USER_NAME/ninja

# To change ownership of the shared directories.
                   chown -R $USER_NAME:$GROUP_NAME  /home/$USER_NAME/team
                   chown -R $USER_NAME:shared_group /home/$USER_NAME/ninja

# To change permissions of the shared directories.
                   chmod 770 /home/$USER_NAME/team
		   chmod 770 /home/$USER_NAME/ninja
		   ;;

# To change a user shell.
changeShell)
                   SHELL=$2
		   USER_NAME=$3
		   chsh -s $SHELL $USER_NAME
		   ;;

# To change user password.
changePasswd)
                  USER_NAME=$2
		  passwd $USER_NAME
		  ;;

# To delete a user.
delUser)
                 USER_NAME=$2
		 userdel -r $USER_NAME
		 ;;

# To delete a group.
delTeam)
                 GROUP_NAME=$2
		 groupdel $GROUP_NAME
		 ;;

# To list users.
lsUser)
                
                path=$2      # "/var/log/user.log"
		cat $path 
		;;

# To list groups.
lsTeam)
                
                path=$2       #"/var/log/group.log"
		cat $path
		;;
            

*)
       echo"please provide valid input"
;;
	       
esac
