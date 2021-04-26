% plotting modcell-will
filename = 'wGCP-.csv';
plotPhenoSpaceFromDesign(prodnet,filename,8,3,20) 
plotBestVsMostCompatible(prodnet, filename, 0.3)

plotBestVsSelected(prodnet,filename,8)