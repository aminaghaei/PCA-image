clc; clear;
nBasesMax = 120; 
fontSize = 15;

origImage=imread('Golden-Gate-Bridge.jpg');   % [n1 x n2 x 3]  For portrait images n1 < n2
unrollImage=[origImage(:,:,1), origImage(:,:,2), origImage(:,:,3)];   % [3n2 x n1]

origMemory = numel(origImage) / 1024;
fprintf('Size of the orignal image is %d x %d x %d\n', size(origImage));
fprintf('The original image takes %7.0f KB of memory\n', origMemory)

[U,S,V] = svd(im2double(unrollImage));
    % [U] = [3n2 x 3n2]
    % [S] = [3n2 x  n1]
    % [V] = [ n1 x  n1]

% Calculate the total energy corresponding to the original image
totEnerg = 0;
for i = 1:min(size(S,1), size(S,2))
    totEnerg = totEnerg + S(i,i)*S(i,i);
end
    
% For ploting the images
figure1 = figure('units','normalized','outerposition',[0 0 1 1]);   set(gcf,'color','w')

for kk = 1:4
    k = kk * ceil(nBasesMax / 4);
    
    romEnerg = 0; % Reduced order energy
    rImage = zeros(size(unrollImage));   % [3n2 x n1]
    for i=1:k
        rImage = rImage + S(i,i) * (U(:,i)*V(:,i)');
        romEnerg = romEnerg + S(i,i)*S(i,i);
    end
    % So we have kept only (3n2 + n1) x nBases information
    
%     rImage = rImage';
    ss = size(rImage,2)/3;
    rImageRoll(:,:,1) = rImage(:,     1:  ss);
    rImageRoll(:,:,2) = rImage(:,  ss+1:2*ss);
    rImageRoll(:,:,3) = rImage(:,2*ss+1:3*ss);

    memoryNeeded = (size(S,2) + size(S,1))*k / 1024;
    relEnerg = romEnerg/totEnerg;
    fprintf('--------------- k = %d ------------------\n', k)
    fprintf('The rom-svd image takes %d KB of memory\n', memoryNeeded)
    fprintf('The rom-svd image takes %5.2f memory compared to the origanl image\n', memoryNeeded/origMemory)
    fprintf('The relative energy is: %6.3f. So the error in the energy of the snapshot is %5.2f%%\n', relEnerg, (1-relEnerg)*100)

    % plot
    sp = subplot(2,2,kk);
    image(rImageRoll)
    title(['k = ' num2str(k) ' , Memory = ' num2str(memoryNeeded) ' KB'] , 'FontSize',fontSize , 'FontName','Arial');
    axis equal
    
    pos1 = get(sp, 'Position'); % gives the position of current sub-plot
    new_pos1 = pos1 +[-0.15 -0.07 0.2 0.07];
    set(sp, 'Position',new_pos1 ); % set new position of current sub - p
end

%%
% ic = 0;
% for i=1:3:size(origImage,1)
%     ic = ic + 1;
%     jc = 0;
%     for j=1:3:size(origImage,2)
%         jc = jc + 1;
%         image2(ic,jc,:) = origImage(i,j,:);
%     end
% end
% % Plot the image
% figure1 = figure('units','normalized','outerposition',[0 0 1 1]);   set(gcf,'color','w')
% image(image2)
% axis equal
% title 'method2'