import Data.List

data Vertex = Vertex Int [Int] deriving (Show)

data Graph = Graph [Vertex] deriving (Show)


--------------------------------------------------------------MAIN PART
getAcyclicOrientations :: Graph -> (Int , Graph)
getAcyclicOrientations (Graph vs) = 
    if length vs == 0 then (1, Graph [])
    else (length oriented, head oriented)
    where oriented = acyclic 0 (Graph []) (Graph vs) []

--       vert , G-> -vert, origin,  oldRes,    returnRes
acyclic :: Int -> Graph -> Graph -> [Graph] -> [Graph]
acyclic vert (Graph vs) (Graph originv) orients = 
    if vert == length originv then (Graph vs) : orients
    else if length(neigh) == 0 then acyclic (vert + 1) (Graph ((Vertex vert []) : vs)) (Graph originv) orients
    else extend (getNullAssignment topOrder) (Graph vs)
    where 
        neigh = neighboursI vert vert (Graph originv)
        topOrder = filter ((flip $ elem) neigh)   (getOrdering (Graph vs)) 
        extend assign (Graph verts) =
            if isUnitAssignment assign then acyclic (vert+1) extendedGraph (Graph originv) orients
            else (acyclic (vert+1) extendedGraph (Graph originv) orients) ++ (extend (getClosureAssignment  (getNextAssignment assign) (Graph vs)) extendedGraph)
            where 
                extendedGraph = Graph(newVs)
                newVs = newV : mappedVs
                newV = (Vertex vert localNeigh)
                localNeigh = map fst (filter ((==1).snd) assign)
                mappedVs = map mapVert vs
                mapVert (Vertex v verts) = 
                    if shouldAddEdge then (Vertex v (vert : verts))
                    else (Vertex v verts)
                        where
                            shouldAddEdge = filter (==(v,0)) assign /= []




-----------------------------------------------------------NEIGHBOURS PART 
--             i,    vj,    origin,   neighbours
neighboursI :: Int -> Int -> Graph -> [Int]
neighboursI i vj (Graph originV) = filter (<=i) realN
    where realN = realNeighbours vj (Graph originV)

realNeighbours :: Int -> Graph -> [Int]
realNeighbours v (Graph vs) = getNList( head (filter (findV v) vs))
    where 
        findV v1 (Vertex v2 vs2) = v1 == v2

getNList :: Vertex -> [Int]
getNList (Vertex i lst) = lst

-------------------------------------------------------TOPOLOGICAL ORDERING PART
getOrdering :: Graph -> [Int]
getOrdering (Graph []) = []
getOrdering (Graph verts) = performOrdering verts


performOrdering :: [Vertex] -> [Int]
--                                       left, all, visited, result
performOrdering verts = performOrdering' verts verts ([],       [])
    where 
        performOrdering' [] all (visited, res) = res
        performOrdering' (v:left) all (visited, res) = (performOrdering' left all (visit v all visited res))


visit :: Vertex -> [Vertex] -> [Int] -> [Int] -> ([Int], [Int])
visit (Vertex v ns) all visited res = 
    if elem v visited then (visited, res)
    else if notVisitedN == []  then (v:visited, v:res)
    else  (newVisited, v:newRes)
    where 
        notVisitedN = ns \\ visited
        runOnNeighbours [] (visited, res) = (visited,res)
        runOnNeighbours (x:xs) (visited, res) = runOnNeighbours xs (visit x all visited res)
        (newVisited, newRes) = runOnNeighbours (getNVList (Vertex v ns) all) (v:visited, res)


getNVList :: Vertex -> [Vertex] -> [Vertex]
getNVList (Vertex v lst) verts = filter isNeigh verts
    where
        isNeigh (Vertex i _) = elem i lst

-------------------------------------------------- LEGAL ASSIGNMENT PART

getNullAssignment :: [Int] -> [(Int, Int)]
getNullAssignment [] = []
getNullAssignment (x:xs) = (x, 0) : getNullAssignment(xs)

getNextAssignment :: [(Int, Int)] -> [(Int, Int)]
getNextAssignment lst = fst (foldr getNextAssignment' ([], True) lst)
    where
        getNextAssignment' (key, value) (res, keepAdd) = 
            if keepAdd then ((key, newValue):res, newKeepAdd) else ((key, value):res, keepAdd)
            where
                (newValue, newKeepAdd) = if value == 0 then (1, False) else (0, True)

getClosureAssignment :: [(Int, Int)] -> Graph -> [(Int, Int)]
getClosureAssignment lst graph = foldr getClosureAssignment' [] lst
    where
        getClosureAssignment' (key, 1) res = (key, 1) : res
        getClosureAssignment' (key, value) res = 
            if any ((==1).checkAssignment) ancestors then (key, 1) : res
            else (key, value) : res
            where
                ancestors = intersect (getAncestors key graph) (map fst lst)
                checkAssignment i = snd $ head $ filter ((==i).fst) lst

getAncestors :: Int -> Graph -> [Int]
getAncestors v (Graph verts) = ancestors
    where
        (_, _,ancestors, _) =  getAncestors'( [v], parents [v], [], verts )
        getAncestors' ([], curP, allP , verts) = ([], [], curP ++ allP, [])
        getAncestors' (ofV, curP, allP , verts) = getAncestors'(curP, parents curP, curP `union` allP, verts)
        parents ofV = getParents ofV (Graph verts)


getParents :: [Int] -> Graph -> [Int]
getParents ofV (Graph verts) = parents
    where
        (_, _, parents) = getParents'(ofV, verts, [])
        getParents' ([], verts, res) = ([], [], res)
        getParents' (v:vLeft, verts, res) = getParents'(vLeft, verts, res ++ foundPV)
            where 
                foundPV = map getIndex (filter ( `isParent` v) verts)
                isParent (Vertex i lst) v = elem v lst
                getIndex (Vertex i lst) = i

isUnitAssignment :: [(Int, Int)] -> Bool
isUnitAssignment [] = True
isUnitAssignment (x:xs) = snd x == 1 && isUnitAssignment xs 