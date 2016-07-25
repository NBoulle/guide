%% 20.  Diskfun
% Heather Wilber, June 2016

%% Constructing a Diskfun
% Diskfun is a new part of Chebfun designed for computing with 
% bivariate functions defined on the unit disk. 
% When working with functions on the disk, it is often convenient to
% express them in terms of polar coordinates: Given a function $f(x,y)$ 
% expressed in Cartesian coordinates, we apply the following transformation
% of variables: 
% \begin{equation}
% x = \rho\cos\theta, \qquad y=\rho\sin\theta.
% \end{equation}
% This finds $f(\theta, \rho)$, where $\theta$ is the \textit{angular}
% variable and $\rho$ is the \textit{radial} variable. 

%%
% We can construct a function in Diskfun using either coordinate system;
% the default is Cartesian.
% A function in Cartesian coordinates can be constructed as follows: 
%%
g = diskfun(@(x,y) exp(-10*( (x-.3).^2+y.^2)));



%%
% To construct the same function using polar coordinates, we include the 
% flag 'polar' in the construction command. The result using either 
% coordinate system is the same up to approximately machine precision: 

%%

f = diskfun(@(t, r) exp(-10*( (r.*cos(t)-.3).^2+(r.*sin(t)).^2)), 'polar');
plot(f)
view(3)
norm(f-g)


%%
% The object we have constructed is called a diskfun. 
%%
f


%% 
% The output describes the {\em numerical rank} of $f$, as well as the
% approximate maximum absolute value (the vertical scale).

%%
% Conveniently, we can evaluate $f$ using points written in either 
% polar or Cartesian coordinates. This setting is stored as the 'coords' 
% parameter. Here, it has been set to polar coordinates: 
%%
f.coords


%%
% To evaluate in Cartesian coordinates, we must include the 'cart' flag: 

[   f(sqrt(2)/4, sqrt(2)/4, 'cart')    f(pi/4,1/2)  ]

%%
% Alternatively, we can change the default `coords' setting:
%%
f.coords = 'cart'

f(sqrt(2)/4, sqrt(2), 4)
%%
% We can also evaluate a univariate 'slice' of $f$, either radial or 
% angular. The result is returned as a chebfun, 
% either nonperiodic or periodic (respectively).
% Here, we plot three angular slices at
% the fixed radii $\rho = 1/4, 1/3, 1/2$. 
%%
f.coords='polar';
f1 = f(:,1/4);
f2 = f(:,1/3);
f3 = f(:,1/2);
plot(f1,'b', f2,'r', f3,'k')


%%
% As with the rest of Chebfun, Diskfun is designed to perform operations at
% essentially machine precision, and using Diskfun requires no special 
% knowledge concerning the underlying discretization procedures.  
% Currently, there are more than 100 operations available.

%% Basic operations
% A suite of commands are available for computing with functions on the 
% disk. For example, the integral of the function  
% $g(x,y) = -x^2 -3xy-(y-1)^2$ over the unit disk is 
% found as follows: 

%%
f = diskfun(@(x,y) -x.^2 - 3*x.*y-(y-1).^2)
sum2(f)

%% 
% The exact answer is $-3\pi/2$: 
%%
-3*pi/2

% Since the area of the unit disk is $\pi$, the mean of $f$ should be
% $-3/2$: 
%%
mean2(f)
%% 
% It is also possible to integrate over a portion of the disk. 
% (add code for this)
%%
% We can also integrate along a contour line parametrized as a
% complex-valued chebfun. For example, consider the following diskfun 
% and contour line: 
%%

f = diskfun(@(x,y) sin(3*x.*y)); 
c1 = chebfun(@(x) .5.*exp(i*x).*cos(2*x),[0 2*pi]); 

plot(f-50)
hold on
plot(c1, 'k', 'Linewidth', 1.5)
hold off
%%
% The integral along the contour line should be zero. 

%%

integral(f, c1)

% The contour integral of $f$ along the unit circle should also be zero. 
% We can compute this quickly using the 'unitcircle' flag. 
%%
integral(f, 'unitcircle')


%%
% We can also find global maxima and minima. Here, we plot a function
% along with its maximum value.

%%
 f = @(x,y) cos(15*((x-.2).^2+(y-.2).^2)).*exp(-((x-.2))^2-((y-.2)).^2);
 f = diskfun(f);
 [j, k] = max2(f) 
 plot(f)
 colorbar 
 hold on
 plot3( k(1),k(2),j, 'r.', 'Markersize', 30);
 hold off
 
 %%
 % We can also return the location of the maximum in polar
 % coordinates if preferred: 
 
 [jp, kp] = max2(f, 'polar');
 
 [kp*cos(jp) kp*sin(jp)]
 
%%
% We can visualize a diskfun in many ways.  Here is a contour plot,
% with the zero contours displayed in black:
%% 
contour(f, 'Linewidth', 1.2)
colorbar
hold on
contour(f, [0 0], '-k', 'Linewidth', 2)
hold off
 
%%
% The roots of a function (1D contours)
% can also be found explicitly. They are stored as 
% a cell array of chebfuns. Each cell consists of two chebfuns 
% that parametrize the contour. 
%%
r = roots(f);
plot(f)
hold on
for j = 1:length(r)
    rj = r{j}; 
    plot(rj(:,1), rj(:,2), '-k', 'Linewidth', 2)
end
hold off
 
%%
% Differentiation on the disk with respect to the polar variable $\rho$
% can lead to singularities, even for smooth functions. 
% For example, the function $f(\rho, \theta) = \rho^2$ is smooth 
% on the disk, but $\partial f/ \partial \rho = 2 \rho$ is not 
% smooth. For this reason, differentiation in
% diskfun is done with respect to the Cartesian coordinates, $x$ and $y$.
% TO DO: (pick a better example.)

%%
% Here we examine a  harmonic conjugate pair of functions.
   u = diskfun(@(x,y) x.*y-x+y);
   v = diskfun(@(x,y) -1/2*x.^2+1/2*y.^2-x-y);
%%
% We can check that these functions satisfy the Cauchy-Riemann equations. 
% First, we compute $\partial u / \partial y$: 
 
%%
dyu = diffy(u);  
%%
% Next, we find $\partial v / \partial x$: 
 
dxv = diffx(v); 
 
%%
% It should be true that $u_y +v_x =0$: 
 
norm(dyu+dxv)
 
%% 
% Likewise, we check that $\partial u /\partial x$ =\partial v / \partial
% y$: 
 
norm(diffx(u) -diffy(v))

 
%%
% TO DO:(maybe replace with this example instead): 
% Here, we examine some derivatives of a function involving the Bessel
% function.
f = diskfun(@(x,y) besselj(0, 5*y).*besselj(0, 5*(x-.1)).*exp(-x.^2-y.^2));
plot(f)
snapnow

plot(diffx(f))
title('derivative of f with respect to x')
snapnow

plot(diffy(f))
title('derivative of f with respect to y')
snapnow

plot(laplacian(f))
title('Scalar laplacian of f')
snapnow

%% Solving Poisson's equation
% We can use Diskfun to find solutions to Poisson's equation on the disk. 
% In this example, we find $u(\theta, \rho)$ in 
% \[ \Delta^2 u = f, \qquad f(\theta, 1) = 1, \]
% where $(\theta, \rho) \in [-\pi, \pi, 0, 1]$ and 
% $f = sin\left( 21 \pi \left(1 + \cos(\pi \rho)
% \right) \rho^2-2\rho^5\cos \left( 5(t-.11)\right) \right)$.
%%


%% Algebra on diskfuns
% We can add, subtract, or multiply several diskfuns together to create new
% diskfuns. 

f = diskfun(@(th, r) -10*cos(((sin(pi*r).*cos(th) + 10*sin(2*pi*r).*sin(th)))/4), 'polar')
g = diskfun(@(x,y) exp(-10*( (x-.3).^2+y.^2)));
plot(g)
axis square
view(2), snapnow

h = g+ f;
plot(h)
axis square
view(2), snapnow

h = g - f;
plot(h)
axis square
view(2), snapnow
 
h = g.*f; 
plot(h)
axis square 
view(2)


%% Vector Calculus
% Vector-valued functions and operations on the disk are performed using 
% {\em Diskfunv}. Here, we define a diskfun and find its gradient, which is
% returned as a diskfunv object.

%%
psi = @(x,y) 10*exp(-10*(x+.3).^2-10*(y+.5).^2)+10*...
    exp(-10*(x+.3).^2-10*(y-.5).^2)+ 10*(1-x.^2-y.^2)-20;

phi = @(x,y) 10*exp(-10*(x-.6).^2-10*(y).^2);

f = diskfun(psi)+diskfun(phi);
u = grad(f)


%%
% The vector-valued function $u(x,y)$ consists of two components, ordered 
% as $x$ and $y$, respectively. Each of these is stored as 
% a diskfun object. We use the Cartesian coordinate system because it is 
% common to do so in application, and also because this ensures that
% each component is a smooth function on the disk. The unit vectors 
% in the polar and radial directions are discontinuous at the origin of 
% the disk, and working with them can lead to singularities.

plot(f)
hold on
quiver(u, 'k')
hold off

 %%
 % Once a diskfunv is created, we can apply several operations.  
 % For example, the divergence is given by
 %%
 D = div(u); 
 contour(D, 'Linewidth', 1.5)
 hold on
 quiver(u, 'k')
 hold off
 
 
 % Several vector calculus operations are available.
 % For example, since $u$ is a gradient field, we expect that it has zero 
 % curl and that any line integral on a closed contour will compute to zero:
 
 curl(u)
 norm(C)
 
 %%
 
 integral(u, 'unitcircle')
 
 %%
 % We can perform a variety of algebraic and
 % calculus-based operations using diskfunvs. For a complete listing of the
 % available operations, type { \tt methods diskfunv}.
 

%% What is a diskfun?
% The underlying algorithm for constructing diskfuns adaptively selects and stores a
% collection of 1D circular and radial ``slices" of a function $f$ on the unit disk to create a representation of f$ that is
% compressed, low rank approximation to $f$. The idea used to construct
% this low rank approximation is similar to what is used in Chebfun2.
% These slice are formed through the selection of pivot values sampled from
% the function, and rely on symmetry features that enforce smoothness over the pole of the
% disk [1]. The numerical rank of a diskfun corresponds to the number of slices it is composed of. We can view the slices and pivots using the plot command. 

%%
g =diskfun(@(th, r) -cos(((sin(pi*r).*cos(th) + sin(2*pi*r).*sin(th)))/4), 'polar');
plot(g)
hold on
plot(g, 'k*-', 'Linewidth', 1.5)

%%
% There are 9 circular slices and 9 radial slices. The astersiks
% represent the pivot values. There are twice as many pivots because they
% are sampled symmetrically to ensure smoothness. 

%% References
% [1] A. Townsend, H. Wilber, and G. Wright, Numerical computation with 
% functions defined on the sphere (and disk), submitted, 2016.
