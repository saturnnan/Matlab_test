function [ output_args ] = ArrayDrawing3D( ArrayPar )
%   ARRAYDRAWING3D 此处显示有关此函数的摘要
%   此函数的目的是，画出探头上每个换能片的位置排布。
%   方法来源：http://blog.sina.com.cn/s/blog_6496e38e0102vi7e.html，具体自己看。
figure(ArrayPar.OutFileNumber);
for iElement = 1:ArrayPar.EleNum
    % 画换能片
    theta = linspace(0,2*pi,100);
    MatrixNull = null(ArrayPar.ElePos.NormVector(iElement,:));
    VectorA = -MatrixNull(:,2).';
    VectorB = MatrixNull(:,1).';
    VectorN = ArrayPar.ElePos.NormVector(iElement,:);
    VectorN = VectorN/norm(ArrayPar.ElePos.NormVector(iElement,:));	% 向量单位化
    
    CenterX = ArrayPar.ElePos.CartCoor(iElement,1);
    CenterY = ArrayPar.ElePos.CartCoor(iElement,2);
    CenterZ = ArrayPar.ElePos.CartCoor(iElement,3);

    XArray = CenterX + ArrayPar.EleR*(VectorA(1)*cos(theta) + VectorB(1)*sin(theta)); %圆上各点的X坐标
    YArray = CenterY + ArrayPar.EleR*(VectorA(2)*cos(theta) + VectorB(2)*sin(theta)); %圆上各点的Y坐标
    ZArray = CenterZ + ArrayPar.EleR*(VectorA(3)*cos(theta) + VectorB(3)*sin(theta)); %圆上各点的Y坐标
    
    plot3(XArray,YArray,ZArray,'r-');
    xlabel('X-Axis');
    ylabel('Y-Axis');
    zlabel('Z-Axis')
    hold on;
    axis equal;
    fill3(XArray,YArray,ZArray,'r');
    hold on;
    
    % 画法向量
    t1 = linspace(0,0.12,100);
    plot3(CenterX + VectorN(1)*t1, ...
          CenterY + VectorN(2)*t1, ...
          CenterZ + VectorN(3)*t1,'b--');
end
% 画笛卡尔坐标系原点
plot3(0,0,0,'bo');
hold off
end