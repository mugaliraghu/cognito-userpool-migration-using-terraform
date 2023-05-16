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

after that go to the UserPool1 folder and navigate to the main file and run the command
```t
terraform init
```
then, use need to use the below command to validate the file
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
 
 open the App integration menu in that you will get client details as shown, if you open app client you can see host ui page.
 
![Screenshot (106)](https://user-images.githubusercontent.com/120295902/235735658-8d887291-8903-4c34-a01c-e623d0a8aaa0.png)

The host ui page as shown below, here we can see callback url's and logout url's.

![Screenshot (104)](https://user-images.githubusercontent.com/120295902/235735667-8992eee2-d7dd-44ab-9702-85e56272d267.png)

enter "Hosted Ui".to get the application login page

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

in the above user pool, Its only having default attributeslike Email and Password, but now i need to add two more attrubute like Name and phone No but after cretaing Userpool there is no permission to change the attribute, That's why i created a new userpool, that is "UserPool2".

Go to the Userpool2 folder and navigate to the main file, do the terraform commands as we did above.

To verify that go to aws management console cognito service and search with the name you given while creating UserPoolI(in my case i have given mypool1) and in the  app client enter into your client and if you launch the host Ui, you will redirect to url, in that enter SignUp to see the new attributes as shown in image.

![Screenshot (127)](https://user-images.githubusercontent.com/120295902/236803734-bc561cf4-36f7-41a5-a9ff-916ec8ab47bd.png)

