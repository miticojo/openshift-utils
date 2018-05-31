## A list of useful command tricks

### Nodes

* List nodes with comma<br> 
  ```
   oc get nodes -o custom-columns="name:.metadata.name" --no-headers | xargs -I {} echo -n "{},"
  ```
 
### Network

* Test SDN for all nodes<br> 
  ```
  oc get hostsubnet -o custom-columns="subnet:subnet" | grep 10 | awk -F'.' '{print $1 "." $2 "." $3 ".1" }' | xargs -I {} ping -c 1 {}
  ```
