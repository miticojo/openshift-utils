## A list of useful command tricks

### Client
* Get latest version of linux client
  ```
  curl -s https://api.github.com/repos/openshift/origin/releases/latest | jq -r ".assets[] | select(.browser_download_url | contains(\"linux\")) | select(.browser_download_url | contains(\"server\") | not ) | .browser_download_url"
  ```


### Nodes

* List nodes with comma<br> 
  ```
   oc get nodes -o custom-columns="name:.metadata.name" --no-headers | xargs -I {} echo -n "{},"
  ```
 
### Network

* Test SDN for all nodes<br> 
  ```
  oc get hostsubnet -o custom-columns="subnet:subnet" --no-headers | awk -F'.' '{print $1 "." $2 "." $3 ".1" }' | xargs -I {} ping -c 1 {}
  ```
