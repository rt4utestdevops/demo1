package t4u.util;


import java.io.Serializable;
import java.util.Date;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

public class JwtTokenUtil implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final long ACCESS_TOKEN_VALIDITY_SECONDS = 120;
    public static final String SIGNING_KEY = "RANET4U";
    public static final String TOKEN_PREFIX = "Bearer ";
    public static final String HEADER_STRING = "Authorization";
    
    public String getUsernameFromToken(String token) {
    	String username;
        try {
            final Claims claims = this.getAllClaimsFromToken(token);
            username = claims.getSubject();
        } catch (Exception e) {
            username = null;
        }
        return username;
    }

    public Date getExpirationDateFromToken(String token) {
    	Date username;
        try {
            final Claims claims = this.getAllClaimsFromToken(token);
            username = claims.getExpiration();
        } catch (Exception e) {
            username = null;
        }
        return username;
    }

//    public  T getClaimFromToken(String token, Function<T, R> claimsResolver) {
//        final Claims claims = getAllClaimsFromToken(token);
//        return claimsResolver.apply(claims);
//    }

    private Claims getAllClaimsFromToken(String token) {
        return Jwts.parser()
                .setSigningKey(SIGNING_KEY)
                .parseClaimsJws(token)
                .getBody();
    }

    
    public Boolean isTokenExpired(String token) {
        final Date expiration = getExpirationDateFromToken(token);
        if(expiration == null)
        	return null;
        else
           return expiration.before(new Date());
    }

//    public String generateToken(UserBean user) {
//        return doGenerateToken(user.getUserName());
//    }

    private String doGenerateToken(String subject) {

        Claims claims = Jwts.claims().setSubject(subject);
       // claims.put("scopes", Arrays.asList(new SimpleGrantedAuthority("ROLE_ADMIN")));

        return Jwts.builder()
                //.setClaims(claims)
                .setIssuer("RANET4U")
//                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + ACCESS_TOKEN_VALIDITY_SECONDS*1000))
                .signWith(SignatureAlgorithm.HS256, SIGNING_KEY)
                .compact();
    }

    public Boolean validateToken(String token, UserBean userDetails) {
        final String username = getUsernameFromToken(token);
        return (
              username.equals(userDetails.getUserName())
                    && !isTokenExpired(token));
    }

    
    public static void main(String[] args) {
    	System.out.println(System.currentTimeMillis());
//		JwtTokenUtil token = new JwtTokenUtil();
//		UserBean user = new UserBean("prathi","password");
//		System.out.println(token.generateToken(user));
//		
//		System.out.println(token.isTokenExpired(token.generateToken(user)));
		
	}
}