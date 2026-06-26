# This is a about a problem using ONE session in three apps

1) oc3.baiti.net
2) oc4.baiti.net
4) oc5.baiti.net

- Check the ansible playbook how the docker stacks are built

- the run in oc3.baiti.net, you can ssh to it, use sudo

- The dev flow is to have the sources HERE on localhost, commit push into the repos and pull into the docker stacks

- OC3 is a legacy environment, analyze its concepts (brief!), we have a new app, oc4, and we can redirecct pages from
  oc3 to oc4 if the user checks "use new ui"

- Scenario: log into oc3.baiti.net as "hxdimpf/hxdimpf", check "use new UI", click on a cache link, which redriects
  successfully to the new page on oc4.baiti.net

- now since the cache in question is MINE, I can edit it, make some changes, do "Save" and now it fails with "not authorized"
  so oc4 doesn't realizt that it is me. Analyze that problem, show me whats wrong and propose a fix
