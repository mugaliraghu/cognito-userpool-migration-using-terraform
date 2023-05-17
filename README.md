# cognito-userpool-users-migration-using-terraform

## Objective
I created an Amazon Cognito user pool and now I want to change the standard attributes required for user registration, But I am unable change standard user pool attributes after a user pool is created. Instead, created a new user pool with the attributes that i want to require for user registration. Then i  migrated  existing users to the new userpool using cognito-backup-restore.
cognito-backup-restore tries to  providing a way to backup users from cognito pool(s) to json file and vice-versa.

## Steps

Clone the Project and navigate to the folder "cognito-app" and run the below command.
```t
python -m http.server 
```
the code will run on the PORT 8000,open the Browser and run the Below url
```t
localhost:8000
```
you will get the output as shown in below image.

![Screenshot (95)](https://user-images.githubusercontent.com/120295902/235646615-444e1946-0323-4395-9fac-0d55266d13d6.png)

after that go to the Userpool1 folder and navigate to the main file and run the command
```t
terraform init
```
then, i need to use the below command to validate the file
```t
terraform validate
```
and terraform plan will generate execution plan, showing you what actions will be taken without actuallay performing planned actions.
```t
terraform plan
```
after perform below command to deploy the application in aws and '--auto-approve' applying changes without having to interactively type 'yes' to the plan.
```t
terraform apply --auto-approve
```
to verify the resources, open the management console and go to the "cognito" search the name of the userpool that you given while creating terraform code.

![Screenshot (112)](https://user-images.githubusercontent.com/120295902/235833543-701fa476-af86-4e2f-88b1-c0553e4a602d.png)
 
 open the App integration menu in that i will get client details as shown, if i open app client you can see host ui page.
 
![Screenshot (106)](https://user-images.githubusercontent.com/120295902/235735658-8d887291-8903-4c34-a01c-e623d0a8aaa0.png)

The host ui page as shown below, here you can see callback url's and logout url's.

![Screenshot (104)](https://user-images.githubusercontent.com/120295902/235735667-8992eee2-d7dd-44ab-9702-85e56272d267.png)

launch "Hosted Ui".to get the application login page

![Screenshot (107)](https://user-images.githubusercontent.com/120295902/235735686-00932550-ff20-49eb-b475-e155bbed984b.png)

after launching "Hosted UI" it will redirected to the website, copy that url and paste it inside the Cognito app files, replace "#" with url in index.html
as shown in below image

![Screenshot (100)](https://user-images.githubusercontent.com/120295902/235729317-90441b7e-8859-4a6b-b343-2aaae7b733e0.png)

and do same in logged_out.html(same url used for both index.html and logged_out.html).

![Screenshot (102)](https://user-images.githubusercontent.com/120295902/235729341-80a18471-a6dc-4690-90ca-606b7d86db81.png)

for logged_in.html do some changes in url, that is replace login with logout, logged_in with logged_out, redict_uri with logout_uri and remove response type and scope. As shown in below image.

![Screenshot (101)](https://user-images.githubusercontent.com/120295902/235729327-838b19c6-7737-4cdb-8edf-202f523a8126.png)

Now, Signup application with email and password, it will sent verification code to the email, as shown.

![Screenshot (107)](https://user-images.githubusercontent.com/120295902/235737171-fbb61930-82e8-46f3-89e0-7fda2814734a.png)

enter the verification code.

![Screenshot (108)](https://user-images.githubusercontent.com/120295902/235737176-95e4bee9-a977-4fae-a0d2-6c87ff00b74b.png)

after validation, the application is going to logged_in, As shown

![Screenshot (109)](https://user-images.githubusercontent.com/120295902/235737180-c09e6ba9-401f-4f34-a59d-d57bb0ef6c6e.png)

If you do logout, it will redirect to the page, As shown

![Screenshot (110)](https://user-images.githubusercontent.com/120295902/235737187-15d02c48-8172-4b71-a04d-a43ca9b2644c.png)

in the above user pool, Its only having default attributes like Email and Password, but now i need to add two more attrubute like Name and phone No but after cretaing Userpool there is no permission to change the attribute, That's why i created a new userpool, that is "UserPool2".

Go to the Userpool2 folder and navigate to the main file, do the terraform commands as you did above.

To verify that go to aws management console cognito service and search with the name you given while creating UserPoolI(in my case i have given name as mypool1) and in the  app client enter into your client and if you launch the host Ui, you will redirect to url, in that enter SignUp to see the new attributes as shown in image.

![Screenshot (127)](https://user-images.githubusercontent.com/120295902/236803734-bc561cf4-36f7-41a5-a9ff-916ec8ab47bd.png)

<!--  Do same like above, after launching "Hosted UI" it will redirected to the website, copy that url and paste it inside the Cognito app files, replace old url  with new url for index.html, logged_in.html and make some changes in logged_out.html like before and save it. -->
 
 Now, its time to migrate users from old userpool to new userpool.it needs Ec2 instance with cognito-backup-restore Package, To install cognito-backup-restore you need npm package, for   npm you need nodejs.
 
 Go to the folder Ec2 instance folder, in that i have created a terraform file which will create ec2 instance, in that just change the "ami" and "key_name". It will create Ec2 instance with  the  name of "cognito_ec2". And i have created remote-exec provisioner in that i have added required packages installation like aws cli, nodejs and cognito-backup-restore. Make sure the path of the key_name and host has be changes on your configuration.
 
Now, Execute terraform commands
```t
terraform init
```
```t
terraform validate
```
```t
terraform plan
```
```t
terraform apply --auto-approve
```
Go to the management console, search instance name that you given in terraform(cognito_ec2), connect using "Ec2 instance connect and login as a root user using command
```t
sudo su
```
we installed aws cli, nodejs, and npm. To cross verify check with below commands.
```t
aws --version
```
```t
node -v
```
```t
npm -v
```
The below command is use to get "AWS Access Key ID", "AWS Secret Access Key", "region name" and "Default output format" as shown in below. it will give access to my EC2 instance to retrive the data.
```t
aws configure
```
![Screenshot (145)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/7bdab198-e4ca-4458-8146-cc4964ebce3a)

after checking all of these to enter the command. "cbr" it will show two values that is "Backup" and "Restore. As shown in image. 
### Backup: 
it is used to retrive the user date form the clients and it stores as a json file in my instance.
### Restore:
it is used restore the users to new user pool.

```t
cbr
```
if u select Backup, it will ask AWS profile and Region you want retrive the data. After selection it will the cognito userpools in that region. you have to select the userpool that you are trying to migrate users as shown.

![Screenshot (148)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/58ddf9d1-1157-4c23-88b5-c252844e9564)

Here i will select my userpool(mypool) and  it will ask the directory which is where to store the json file, I will choose the default one and it will store in "/home/ubuntu/", it will show the  Json Exported Successfully as shown in image.

![Screenshot (152)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/3f214aeb-d87a-48ad-b46f-c127332248fa)

To cross verify just run ls command
```t
ls
```
it will show the json file, the run the below command 
```t
cat <json file>
```
it will show the user details that took backup from my user pool as shown 

![Screenshot (153)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/3a78388f-5ca9-470b-bd44-d020650bbbf3)

Next you need to restore the data in new user pool, To do that use the command "cbr" and enter restore
```t
cbr
```
after selecting restore, same like it will ask profile and region, In which region userpool you want to store as shown.

![Screenshot (154)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/14e2d80b-98f7-4054-94a3-185efa61c452)

after that you have to select User pool that you want to migrate(mypool1) and you want to select the path were json file is present, After selection it will show "Users Imported Successfully" as shown.
It will indicate the users migration has done successfully.

![Screenshot (156)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/58058713-dd9c-417c-930b-c0ac21a24455)

Now, to check the migrated user, go to the aws management console cognito section check with new userpool, in users section you can see the user details as shown.

![Screenshot (157)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/1383b452-7a30-40e8-944d-1012c0f631a5)

after successful migration automatically user get a default username and password for registered mail as shown in image.

![Screenshot (158)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/edc026fd-ccfa-426e-af20-b5252f25924c)
<!-- 
Here, you can see in confirm status it showing "force change password" to do that go to the App integration section, open your client and launch "Host UI" after launching tak the url and paste it in a cognito app files as you did above. -->

after if you do login with username and password that you got in mail, it will redirect to create a New password and enter a new attributes that you added in new pool like "Name" and "Phone number" as shown in image
![Screenshot (159)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/3485fe7a-8b8d-4299-8a27-b63704d9b0fd)

after entering all the details it's going to logged_in successfully as shown in image.

![Screenshot (160)](https://github.com/mugaliraghu/cognito-users-migration-using-terraform/assets/120295902/a79e36df-9530-4626-a1a6-60a48c7e0388)


