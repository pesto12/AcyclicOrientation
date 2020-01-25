# All possible acyclic graph orientations

## About:
This is my implementation of [algorithm](https://www.cos.ufrj.br/uploadfile/es40596.pdf) in Haskell programming language.
It works in following way: firstly find all possible orientations, then return number of those and some orientation.
Graphs are represented by using adjacency list, so in input undirected graph each edge u-v is represented twice, in u's adjacency list and in v's adjacency list.

## Usage
User may interact with the program in two ways:

### File input and output
  After loading the source code, user run's ```main``` command. Then user is asked to enter input and output files.
  Input file containd description of undirected graph. It must be correct, because program does not validate input.
  Structure of input file looks like this:
```
Vertex0
[Neighbour0, Neighour1 .. NeighourK]
.
.
.
VertexN
[Neighbour0, Neighour1 .. NeighourL]
```
Where VertexN and NeighourY are not negative integer. Vertexes should be enumerated from 0 to N as countinuous sequence.
Example input file content:
```
0
[4,5]
1
[3,4]
2
[3,5]
3
[1,2]
4 
[0, 1]
5
[2, 0]
```
### Function usage
User has a possibilit to interact directly with functions that implement acyclic orientaton generation algorithm.
The key fuction is called getAcyclicOrientations. It takes a graph as parameter.
The result of calling the function is a pair 
```(Number of orientations, example orientation)```
Data structures that are used within the program :
```
data Vertex = Vertex Int [Int]

data Graph = Graph [Vertex]
```
Some test data:
```
getAcyclicOrientations (Graph [Vertex 0 [1], Vertex 1[0]])
getAcyclicOrientations (Graph [Vertex 0 [4,5], Vertex 1 [3,4], Vertex 2 [3,5], Vertex 3 [1,2], Vertex 4 [0, 1], Vertex 5 [2, 0 ]])
getAcyclicOrientations (Graph [Vertex 0 [3,2], Vertex 1[3,2],Vertex 2[0,1], Vertex 3 [0,1]])
getAcyclicOrientations (Graph [Vertex 0 [1,2,3,4], Vertex 1 [0,2,3,4], Vertex 2 [0,1,3,4], Vertex 3 [0,1,2,4], Vertex 4 [0,1,2,3]])
```

## Additional notes:
If as a result is needed not only example graph orientation but all of them, you can use additional funcion in the same way as standard one.
```__getAcyclicOrientations :: Graph -> (Int, [Graph])```
