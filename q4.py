import time

'''
ALgo:
Öncelikle satırları sol baştan tek tek saymaya başlar.
Eğer denk geldiği değer bir ise mark_component fonksiyonunu girer.
Bu fonksiyonda recursive şekilde adanın büyüklüğünü ölçmek için 
üst, alt, sağ ve soluna recursive şekilde gider ve eğer bulduğu değer 1
ise büyüklüğü arttırıp bu bloğa da aynı işlemleri uygular. 
Her gezilen blok sayıldıktan sonra tekrar aramaya devam etmemesi için değeri 
0 a eşitlenir. Bu şekilde bulun growth lar arasında en büyüğü seçilir. 
'''

def check(i, j, n, m):
#    print("i, j, n, m")
#    print(i, j, n, m)
#    time.sleep(1)
    return i >= 0 and j >= 0 and i < n and j < m


def mark_component(matrix, i, j, n, m, growth):
    if not check(i, j, n, m):
        return 0

#    vis[i][j] = True
    if matrix[i][j] == 1:
        matrix[i][j] = 0
        bottom = mark_component(matrix, i+1, j, n, m, growth)
        up = mark_component(matrix, i-1, j, n, m, growth)
        left = mark_component(matrix, i, j-1, n, m, growth)
        right = mark_component(matrix, i, j+1, n, m, growth)
        growth = bottom + up + left + right + 1
        return growth
#    mark_component(matrix, vis, i+1, j+1, n, m)
#    mark_component(matrix, vis, i-1, j+1, n, m)
#    mark_component(matrix, vis, i+1, j-1, n, m)
#    mark_component(matrix, vis, i-1, j+1, n, m)
    return 0


matrix = [
    [0, 0, 0, 1, 1, 1],
    [1, 1, 0, 0, 1, 1],
    [0, 1, 0, 0, 0, 0],
    [0, 0, 1, 0, 1, 1]
]

row = len(matrix)
col = len(matrix[0])
cnt = 0
max_growth = 0
#vis = [[False for n in range(col)] for m in range(row)]
for i in range(row):
    for j in range(col):
        #if not vis[i][j] and matrix[i][j] == 1:
        if matrix[i][j] == 1:
            cnt += 1
            # call function
            growth = mark_component(matrix, i, j, row, col, 0)
            print("growth:", growth)
            if growth > max_growth:
                max_growth = growth
print("The number of island:", cnt)
print("max: ", max_growth)


