#Toggl day report script

##Instalation

Before first start of script please open terminal, go to toggl tracker directory and run `bash setup.sh` command.

##Usage

For using of toggl report script you must provide 4 parameters.

* **token**

	In Toggl web admin go to [Profile settings](https://toggl.com/app/profile) and on bottom of page you can find your api key in field `API Token`

	Example: `d8c97bb22aa69cef234fc9823e408e9b`

* **project_id**

	In Toggl web admin, go to [Projects list](https://toggl.com/app/projects), than open detail of project (that you want track) and id after last slash in url is project ID.

	Example: `https://toggl.com/app/projects/123456/edit/12345678`
	
	In this case `project_id` is **12345678**

* **month**

	Month number in format M or MM

* **year**

	Year in format YYYY
	
--

To generate csv report run in script root folder: `ruby main.rb --token=<token> --project_id=<project_id> --month=<month> --year=<year>`