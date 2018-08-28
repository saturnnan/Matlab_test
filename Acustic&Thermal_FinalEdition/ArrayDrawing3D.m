function [ output_args ] = ArrayDrawing3D( ArrayPar )
%   ARRAYDRAWING3D �˴���ʾ�йش˺�����ժҪ
%   �˺�����Ŀ���ǣ�����̽ͷ��ÿ������Ƭ��λ���Ų���
%   ������Դ��http://blog.sina.com.cn/s/blog_6496e38e0102vi7e.html�������Լ�����
figure(ArrayPar.OutFileNumber);
for iElement = 1:ArrayPar.EleNum
    % ������Ƭ
    theta = linspace(0,2*pi,100);
    MatrixNull = null(ArrayPar.ElePos.NormVector(iElement,:));
    VectorA = -MatrixNull(:,2).';
    VectorB = MatrixNull(:,1).';
    VectorN = ArrayPar.ElePos.NormVector(iElement,:);
    VectorN = VectorN/norm(ArrayPar.ElePos.NormVector(iElement,:));	% ������λ��
    
    CenterX = ArrayPar.ElePos.CartCoor(iElement,1);
    CenterY = ArrayPar.ElePos.CartCoor(iElement,2);
    CenterZ = ArrayPar.ElePos.CartCoor(iElement,3);

    XArray = CenterX + ArrayPar.EleR*(VectorA(1)*cos(theta) + VectorB(1)*sin(theta)); %Բ�ϸ����X����
    YArray = CenterY + ArrayPar.EleR*(VectorA(2)*cos(theta) + VectorB(2)*sin(theta)); %Բ�ϸ����Y����
    ZArray = CenterZ + ArrayPar.EleR*(VectorA(3)*cos(theta) + VectorB(3)*sin(theta)); %Բ�ϸ����Y����
    
    plot3(XArray,YArray,ZArray,'r-');
    xlabel('X-Axis');
    ylabel('Y-Axis');
    zlabel('Z-Axis')
    hold on;
    axis equal;
    fill3(XArray,YArray,ZArray,'r');
    hold on;
    
    % ��������
    t1 = linspace(0,0.12,100);
    plot3(CenterX + VectorN(1)*t1, ...
          CenterY + VectorN(2)*t1, ...
          CenterZ + VectorN(3)*t1,'b--');
end
% ���ѿ�������ϵԭ��
plot3(0,0,0,'bo');
hold off
end