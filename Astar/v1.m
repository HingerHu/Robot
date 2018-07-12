%Author: XH-Wang
%UCAS-SIA,Shenyang-China
%2018-07-11

clear,clc

startPosition = [1 5];
goalPosition = [8 5];

%载入地图，1代表障碍物，0为自由空间
map = [0 0 0 0 0 0 0 0 0 0;
       0 0 0 1 1 1 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 1 0 0 0 0;
       0 0 0 0 1 0 0 0 0 0;
       0 0 0 1 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0;];
[mapRow, mapCol] = size(map);

if map(startPosition(1), startPosition(2))
    error('Parameters Error! in startPosition');
elseif map(goalPosition(1), goalPosition(2))
    error('Parameters Error! in goalPoaition');
end

%初始化open list 和 close list结构体。
closeList = struct('row', 0, 'col', 0, 'g', 0, 'h', 0);
closeListLength = 0;
openList = struct('row', 0, 'col', 0, 'g', 0, 'h', 0);
openListLength = 0;
%扫描方向
direction = [0, -1; 0, 1; -1, 0; 1, 0];

openList(1).row = startPosition(1);
openList(1).col = startPosition(2);
openListLength = openListLength + 1;

while openListLength > 0
    %寻找f最小的节点
    f = openList(1).g + openList(1).h;
    nodePosition = 1;%记录
    for i = 1:openListLength
        if f > openList(i).g + openList(i).h
            f = openList(i).g + openList(i).h;
            nodePosition = i;
        end
    end
    
    %将f最小的节点放入close list
    closeListLength = closeListLength + 1;
    closeList(closeListLength) = openList(nodePosition);
    openListLength = 0;
    
    if closeList(closeListLength).row == goalPosition(1) &&...
        closeList(closeListLength).col == goalPosition(2)    
        break;
    end
    
    for i = 1:4
        newPosition = [closeList(closeListLength).row, closeList(closeListLength).col] ...
                + direction(i, :);
        if all(newPosition > 0) && newPosition(1) <= mapRow ...
                && newPosition(2) <= mapCol ...
                && map(newPosition(1), newPosition(2)) ~= 1
            flag = false;
            for j = 1:closeListLength
                if closeList(j).row == newPosition(1)...
                        && closeList(j).col == newPosition(2)
                    flag = true;
                    break;
                end
            end
            
            if flag
                continue;
            end
            
            openListLength = openListLength + 1;
            openList(openListLength).row = newPosition(1);
            openList(openListLength).col = newPosition(2);
            openList(openListLength).g = closeList(closeListLength).g + 1;    
            openList(openListLength).h = abs(goalPosition(1) - ...
                openList(openListLength).row) + abs(goalPosition(2) - ...
                openList(openListLength).col);
        end
    end
end

map(startPosition(1), startPosition(2)) = 21;
map(goalPosition(1), goalPosition(2)) = 20;

for i = 2:closeListLength-1
    map(closeList(i).row, closeList(i).col) = 5;
    imagesc(map);
    pause(0.3);
end
