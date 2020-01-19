# All possible acyclic graph orientations

##About:
This it my implementation of [algorithm](https://www.cos.ufrj.br/uploadfile/es40596.pdf) in Haskell programming language.

Some test data:
```
getAcyclicOrientations (Graph [Vertex 0 [4,5], Vertex 1 [3,4], Vertex 2 [3,5], Vertex 3 [1,2], Vertex 4 [0, 1], Vertex 5 [2, 0 ]])
getAcyclicOrientations (Graph [Vertex 0 [3,2], Vertex 1[3,2],Vertex 2[0,1], Vertex 3 [0,1]])
getAcyclicOrientations (Graph [Vertex 0 [1,2,3,4], Vertex 1 [0,2,3,4], Vertex 2 [0,1,3,4], Vertex 3 [0,1,2,4], Vertex 4 [0,1,2,3]])
```
