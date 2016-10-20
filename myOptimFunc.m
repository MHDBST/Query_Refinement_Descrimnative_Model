function muOut = myOptimFunc(Lambda,h1,h2,f,c,NormL)

muOut = -((h1*Lambda(1)) + (h2*Lambda(2)) + (f*Lambda(3)))+(c*NormL);

end