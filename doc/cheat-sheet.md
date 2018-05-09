## A list of useful command tricks**

### Nodes

* List nodes with comma<br> 
  oc get nodes -o custom-columns="name:.metadata.name" --no-headers | xargs -I {} echo -n "{},"
