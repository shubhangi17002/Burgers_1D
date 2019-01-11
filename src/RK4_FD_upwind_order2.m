function y = RK4_FD_upwind_order2 (u,deltat,N,K,F,h,constant_sub)
% Temporal integration of the 1D Burgers equation with an explicit 4 steps Runge-Kutta scheme
% Spatial discretization with a nonlinear discretization second order UP2 scheme for the convective term
%
% The equation to be solved is 
%                  du
%                  -- = f(u,t)
%                  dt
% The explicit 4 steps Runge-Kutta scheme is 
% U(n+1) = U(n) + 1/6(k1 + 2k2 + 2k3 +k4)
% where k1 = f(U(n),t)
%       k2 = f(U(n) + (deltat/2)k1,t + deltat/2)
%       k3 = f(U(n) + (deltat/2)k2,t + deltat/2)
%       k4 = f(U(n) + deltat.k3,t + deltat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% First step
  Un=u;

  ind = zeros(N,5);
  ind(:,1) = -1:N-2; 
  ind(:,2) = 0:N-1; 
  ind(:,3) = 1:N;
  ind(:,4) = 2:N+1;
  ind(:,5) = 3:N+2;
  ind(1,:) = [N-1 N 1 2 3]; 
  ind(2,:) = [N 1 2 3 4]; 
  ind(N-1,:) = [N-3 N-2 N-1 N 1];
  ind(N,:)   = [N-2 N-1 N   1 2];

  one_over_h = 0.25/h;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Second step
  C = - get_nonlinear_term(Un,ind) * one_over_h ;
  k1  = K * Un + C;
  Un2 = Un + deltat * 0.5 * k1;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Third step
  C = - get_nonlinear_term(Un2,ind) * one_over_h ;
  k2  = K * Un2 + C;
  Un3 = Un + deltat * 0.5 * k2;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fourth step
  C = - get_nonlinear_term(Un3,ind) * one_over_h ;
  k3  = K * Un3 + C;
  Un4 = Un + deltat * k3;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fifth step
  C = - get_nonlinear_term(Un4,ind) * one_over_h ;
  k4 = K * Un4 + C;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  y  = Un + deltat*(k1 + 2*k2 + 2*k3 +k4 )/6 +F;
  
end

function vecC = get_nonlinear_term(Un,ind)
  vpip1 = max( ( Un(ind(:,3)) + Un(ind(:,4)) ) * 0.5   ,0); % v+ at node i+1/2
  vpim1 = max( ( Un(ind(:,3)) + Un(ind(:,2)) ) * 0.5   ,0); % v+ at node i-1/2
  vmip1 = min( ( Un(ind(:,3)) + Un(ind(:,4)) ) * 0.5   ,0); % v- at node i+1/2
  vmim1 = min( ( Un(ind(:,3)) + Un(ind(:,2)) ) * 0.5   ,0); % v- at node i-1/2
  vecC = vpip1.*(3*Un(ind(:,3))-Un(ind(:,2))) + ...
         vmip1.*(3*Un(ind(:,4))-Un(ind(:,5))) - ...
         vpim1.*(3*Un(ind(:,2))-Un(ind(:,1))) - ...
         vmim1.*(3*Un(ind(:,3))-Un(ind(:,4)))  ;
endfunction