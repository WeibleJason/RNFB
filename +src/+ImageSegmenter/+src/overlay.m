function outputImage = overlay(foregroundImage,backgroundImage)

    f = figure('Name','overlapped','Color','none');
    set(f,'Toolbar','none');
    set(gca,'YDir','reverse');
    hold on
    boundaries = bwboundaries(foregroundImage);
    numOfBoundaries = size(boundaries, 1);
    for k = 1 : numOfBoundaries
        thisBoundary = boundaries{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 1);
    end
    image = imagesc(backgroundImage);
    colormap gray
    uistack(image,'bottom');
    figure_size = size(backgroundImage);
    truesize([figure_size(1) figure_size(2)]);
    axis off
    colorbar off
    hold off

    outputImage = frame2im(getframe(f));


end

