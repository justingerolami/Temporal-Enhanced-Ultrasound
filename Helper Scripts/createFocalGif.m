function createFocalGif(phantom,filename)

p1=figure;
minV = min(log(1+abs(hilbert(phantom(:)))));
maxV = max(log(1+abs(hilbert(phantom(:)))));
numFrames=200;
for i = 1:numFrames
    img = phantom(:,:,i);
    imagesc(log(1+abs(hilbert(img)_));
	caxis([minV, maxV]);
    %colorbar
    colormap(gray);
    drawnow;
    frame = getframe(p1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1 
       imwrite(imind,cm,filename,'gif', 'Loopcount',4, 'DelayTime',0); 
    else 
       imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0); 
    end 
end
end