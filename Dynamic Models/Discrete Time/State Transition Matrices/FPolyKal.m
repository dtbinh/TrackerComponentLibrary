function F=FPolyKal(T,x,order)
%%FPOLYKAL  Get the state transition matrix for a linear dynamic model
%           of the given polynomial order (number of derivatives of
%           position included) and number of dimensions (generally 3 for 3D
%           motion). order=1 means constant velocity; order=2 means
%           constant acceleration, etc. The state is ordered in terms of
%           position, velocity, acceleration, etc. This transition matrix
%           is used with discretized continuous-time models as well as with
%           direct discrete-time models.
%
%INPUTS: T      The time-duration of the propagation interval.
%        x      The ((order+1)*numDim)X1 target state. This is just used to
%               extract numDim and for functions that expect the first two
%               parameters of a state transition function to be T and x.
%        order  The order >=0 of the filter. If order=1, then it is 
%               constant velocity, 2 means constant acceleration, 3 means
%               constant jerk, etc.
%
%OUTPUTS: F     The state transition matrix under a linear dynamic model of
%               the given order with motion in numDim dimensions where the
%               state is stacked [position;velocity;acceleration;etc] where
%               the number of derivatives of position depends on the order
%               given. Order=0 mean just position.
%
%An expression for obtaining the state transition matrix of a
%polynomial-time Kalman filter is given in terms of a Taylor expansion of e
%raised to a matrix in Chapter 4 of [1]. By examining how the state
%transition matrices evolve as the order goes up, (each unit increase in
%order means one more term in the Taylor series expansion remains) one can
%obtain a general rule for an arbitrary dimensionality. For numDim=1, the
%first row is T raised to powers from 0 to order and those terms are
%divided by the factorial of their exponent. For example, T^n/factorial(n)
%for the nth column in the first row. The other rows are just the same as
%the first, but right-shifted (and zero padded).
%
%The state for the 1D case is assumed to be
%[position;velocity;acceleration;etc] --so in the order of increasing
%derivatives. in the multidimensional case, the same order is preserved, so
%position becomes numDim-dimensional as do velocity, acceleration, etc.
%This means that the values for the 1D case just get repeated.
%
%When using discretized continuous-time models, this transition matrix
%generally goes with a covariance matrix generated by QPolyKal. When using
%direct discrete-time models, it generally goes with a covariance matrix
%generated by QPolyKalDirectDisc.
%
%REFERENCES:
%[1] P. Zarchan and H. Musoff, Fundamentals of Kalman Filtering: A
%    Practical Approach, 3rd ed. Reston, VA: American Institute of
%    Aeronautics and  Astronautics, Inc., 2009.
%
%October 2013 David F. Crouse, Naval Research Laboratory, Washington D.C.
%(UNCLASSIFIED) DISTRIBUTION STATEMENT A. Approved for public release.

xDim=size(x,1);
numDim=xDim/(order+1);

%First, create the matrix for 1D motion
numEl=order+1;
F1=zeros(numEl,numEl);

degList=(0:order)';
F1(1,:)=(T.^degList)./factorial(degList);
for curRow=2:numEl
    F1(curRow,curRow:numEl)=F1(1,1:(numEl-curRow+1));
end

%Now, the elements just get spread across identity matrices that are
%numDim dimensional to form a transition matrix of the desired
%dimensionality. This is done usine a Kronecker product.
F=kron(F1,eye(numDim));

end

%LICENSE:
%
%The source code is in the public domain and not licensed or under
%copyright. The information and software may be used freely by the public.
%As required by 17 U.S.C. 403, third parties producing copyrighted works
%consisting predominantly of the material produced by U.S. government
%agencies must provide notice with such work(s) identifying the U.S.
%Government material incorporated and stating that such material is not
%subject to copyright protection.
%
%Derived works shall not identify themselves in a manner that implies an
%endorsement by or an affiliation with the Naval Research Laboratory.
%
%RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE OF THE
%SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO INDEMNIFY THE NAVAL
%RESEARCH LABORATORY FOR ALL THIRD-PARTY CLAIMS RESULTING FROM THE ACTIONS
%OF RECIPIENT IN THE USE OF THE SOFTWARE.