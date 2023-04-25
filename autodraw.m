flipud(color_matrix);
%%把csv放入工作区，直接右键导入数据，导入成字符串矩阵，命名为simulatoroctoMap1
data_str=simulatoroctoMap1(:,[1,3,4,5,6,7]);
%空闲节点提取
data_str_ob=data_str(find(data_str(:,1)=="SP"),:);
%占据节点提取
data_str_em=data_str(find(data_str(:,1)=="EP"),:);
%节点处理
data_ob=data_str_ob(:,[2,3,4,5,6]);
data_em=data_str_em(:,[2,3,4,5,6]);
str2double(data_ob);
data_em=str2double(data_em);
data_ob=str2double(data_ob);
%去掉盖子
data_em = data_em(data_em(:,3) <75, :);
%清空工作区
close
clc
%画空闲节点
hold off
for i = 1:size(data_ob,1)
x = data_ob(i, 1);
y = data_ob(i, 2);
z = data_ob(i, 3);
size1=data_ob(i,4);
i_voxel = [x, y, z];
d_voxel = [size1, size1, size1];
%指定颜色和透明度
%voxel(i_voxel,d_voxel,[0.4660 0.6740 0.1880],0.3)
voxel(i_voxel,d_voxel,'w',0.25)
end
hold on
%%导入颜色矩阵，命名为color（n行3列，0-1之间）
%%把障碍物节点进行n_bin等分
[~, idx] = sort(data_em(:, 3));
data_em = data_em(idx, :);
n_bins = 16;
edges = linspace(min(data_em(:, 3)), max(data_em(:, 3)), n_bins+1);
counts = histcounts(data_em(:, 3), edges);
groups = findgroups(discretize(data_em(:, 3), edges));
fcn = @(x) {x};
% 按照区间对矩阵进行分割
splitapply(fcn, data_em, idx);
split_data_em=horzcat(data_em,groups);
% 创建一个空的cell数组，用于存放分割后的矩阵
split_em = cell(1,n_bins);
% 遍历数字1到5
for i = 1:n_bins
    % 提取矩阵中第6列等于i的行
    rows = split_data_em(:,6) == i;
    % 组成新的矩阵
    new_matrix = split_data_em(rows,:);
    % 存放到cell数组中对应的位置
    split_em{i} = new_matrix;
end
for i = 1:n_bins
    eval(['sp_em_' num2str(i) ' = split_em{' num2str(i) '};']);
end
%障碍物画图
for j = 1:numel(split_em)
    sp_em = split_em{j};
    color = color_matrix(mod(j-1, size(color_matrix,1))+1,:);
    
    for i = 1:size(sp_em,1)
        x = sp_em(i, 1);
        y = sp_em(i, 2);
        z = sp_em(i, 3);
        size1=sp_em(i,4);
        i_voxel = [x, y, z];
        d_voxel = [size1, size1, size1];
        voxel_ob(i_voxel,d_voxel,color,0.8)
    end
    hold on
end

%图像调整
view(45,45)
light;
light;
light('Position',[1 0 0],'Style','infinite') % 添加位于x轴正方向的白色光源
light('Position',[0 -1 0],'Style','infinite') % 添加位于x轴正方向的白色光源
fig = gcf; % 获取当前图形句柄
filename = 'figure5-1.fig'; % 保存文件名
saveas(fig, filename, 'fig'); % 保存为PNG格式图片
hold off
