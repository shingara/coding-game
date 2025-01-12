import sys
# the standard input according to the problem statement.

# n: the total number of nodes in the level, including the gateways
# l: the number of links
# e: the number of exit gateways
n, l, e = [int(i) for i in input().split()]
link_list = []
for i in range(l):
    # n1: N1 and N2 defines a link between these nodes
    n1, n2 = (int(j) for j in input().split())
    # print("n1, n2:", str(n1), str(n2), file=sys.stderr, flush=True)
    link_list.append((n1, n2))
gateway_list = []
for i in range(e):
    ei = int(input())  # the index of a gateway node
    # print("ei: " + str(ei), file=sys.stderr, flush=True)
    gateway_list.append(ei)

near_node_count = {key: 0 for key in range(n)}
no_gateway_list = link_list.copy()
for n1, n2 in link_list:
    if n2 in gateway_list:
        near_node_count[n1] += 1
        no_gateway_list.remove((n1, n2))
    if n1 in gateway_list:
        near_node_count[n2] += 1
        no_gateway_list.remove((n1, n2))

# 寻找挨着的gateway，没有则返回-1
def get_near_gateway(node):
    for n1, n2 in link_list:
        if node == n1 and n2 in gateway_list:
            return n2
        if node == n2 and n1 in gateway_list:
            return n1
    return -1


# 寻找最短到达出口的路
def find_riskiest_node(start):
    queue = [(start, [])]
    # 用来筛选已经遍历过的节点
    visited = set()
    minPath = n
    while queue:
        # print(queue, file=sys.stderr, flush=True)
        node, path = queue.pop(0)
        if node in visited:
            continue

        path.append(node)
        visited.add(node)
        if node in risk_list:
            print("path before :", str(path), file=sys.stderr, flush=True)
            print("normal_list :", str(normal_list), file=sys.stderr, flush=True)
            path[:] = [si for si in path if si not in normal_list]
            print("path:", str(path), file=sys.stderr, flush=True)
            if len(path) < minPath:
                minPath = len(path)
                riskiest_node = node

        for link in no_gateway_list:
            if link[0] == node:
                queue.append((link[1], list(path)))
            if link[1] == node:
                queue.append((link[0], list(path)))
    return riskiest_node

# 获取随机gateway旁的线
def get_random_link():
    for n1, n2 in link_list:
        if n1 in gateway_list or n2 in gateway_list:
            return n1, n2
    return -1, -1


# game loop
while True:
    si = int(input())  # The index of the node on which the Bobnet agent is positioned this turn
    # print("si: " + str(si), file=sys.stderr, flush=True)

    # 判断该点的下一步是否有危险源，有直接封
    gateway = get_near_gateway(si)
    if gateway > -1:
        print(si, gateway)
        continue

    # 找到所有临近两个gateway的点和只临近一个gateway的点
    risk_list = []
    normal_list = []
    for node in near_node_count:
        if near_node_count[node] == 1:
            normal_list.append(node)
        if near_node_count[node] >= 2:
            risk_list.append(node)
    # 如果没有风险点，那就随机封路
    if not risk_list:
        n1, n2 = get_random_link()
        print(n1, n2)
        link_list.remove((n1, n2))
        continue

    nearest_riskynode = find_riskiest_node(si)
    print("nearest_riskynode:", str(nearest_riskynode), file=sys.stderr, flush=True)
    gateway = get_near_gateway(nearest_riskynode)
    print(nearest_riskynode, gateway)

    near_node_count[gateway] -= 1
    near_node_count[nearest_riskynode] -= 1
    if (nearest_riskynode, gateway) in link_list:
        link_list.remove((nearest_riskynode, gateway))
    else:
        link_list.remove((gateway, nearest_riskynode))
