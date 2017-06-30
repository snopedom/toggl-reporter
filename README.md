Toggl day report script README
-------------------------------

Before first start of script please run 'bash setup.sh' command.

To run script you must provide 4 arguments:

TOKEN
-----
In Toggl web admin go to 'Profile settings' (https://toggl.com/app/profile) and on bottom of page is field 'API token'

Example: d8c97bb22aa69cef234fc9823e408e9b

PROJECT_ID
----------
In Toggl web admin go to Projects list (https://toggl.com/app/projects), than open detail of Erste hub project and last number of url is project ID.

Example: https://toggl.com/app/projects/890996/edit/44903966  --> PROJECT ID is 44903966

MONTH
-----
Number of month in format M or MM

YEAR
----
Year in format YYYY

To generate csv report run in script folder: 'ruby main.rb --token=<TOKEN> --project_id=<PROJECT ID> --month=<MONTH> --year=<YEAR>'