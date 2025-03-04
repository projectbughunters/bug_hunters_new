package kr.co.soft.config;


import javax.annotation.Resource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.mapper.MapperFactoryBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.interceptor.CheckLoginInterceptor;
import kr.co.soft.interceptor.TopMenuInterceptor;
import kr.co.soft.mapper.BoardMapper;
import kr.co.soft.mapper.CommentMapper;
import kr.co.soft.mapper.FavoriteMapper;
import kr.co.soft.mapper.PortfolioMapper;
import kr.co.soft.mapper.ProfileMapper;
import kr.co.soft.mapper.StockDataMapper;
import kr.co.soft.mapper.UserMapper;





@Configuration // 객체 정의
@EnableWebMvc // 어노테이션 설정
@ComponentScan(basePackages = "kr.co.soft.controller")
@ComponentScan("kr.co.soft.beans")
@ComponentScan("kr.co.soft.DAO")
@ComponentScan("kr.co.soft.service")
@PropertySource("/WEB-INF/properties/db.properties")
@PropertySource("/WEB-INF/properties/application.properties")
public class ServletAppContext implements WebMvcConfigurer {
	
	@Value("${db.classname}")
	private String db_classname;
	
	@Value("${db.url}")
	   private String db_url;
	   
	@Value("${db.username}")
	private String db_username;
	   
	@Value("${db.password}")
	private String db_password;
	
	@Value("${db.fetchSize}")
	private int db_fetchSize;
	
	@Value("${upload.path}")
    private String uploadPath;
	
	@Resource(name = "loginUserBean")
	private UserBean loginUserBean;
	
	@Resource(name = "profileBean")
	private ProfileBean profileBean;

	// 정적파일 경로
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		
		// 외부 업로드 파일 매핑
	    registry.addResourceHandler("/upload/**")
	            .addResourceLocations("file:///" + uploadPath + "/");
		// TODO Auto-generated method stub
		WebMvcConfigurer.super.addResourceHandlers(registry);
		registry.addResourceHandler("/**").addResourceLocations("/resources/");
	}

	// view 경로 설정과 jsp 확장자 설정
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		// TODO Auto-generated method stub
		WebMvcConfigurer.super.configureViewResolvers(registry);
		registry.jsp("/WEB-INF/views/", ".jsp");
	}
	/*
	// Properties 파일을 Message로 등록한다
	@Bean
	public ReloadableResourceBundleMessageSource messageSource() {
		ReloadableResourceBundleMessageSource res = new ReloadableResourceBundleMessageSource();
		// 스캔늘 하나 받을경우
		// res.setBasename("/WEB-INF/properties/data1");
		res.setBasenames("/WEB-INF/properties/data1", "/WEB-INF/properties/data2","/WEB-INF/properties/error_message");

		return res;
	}*/
	
	@Bean
	public BasicDataSource dataSource() {
		BasicDataSource source=new BasicDataSource();
		source.setDriverClassName(db_classname);
		source.setUrl(db_url);
		source.setUsername(db_username);
		source.setPassword(db_password);
		
		// fetchSize 설정 (JDBC 기본 설정)
	    source.setDefaultQueryTimeout(db_fetchSize);
		
		return source;
	}
	
	@Bean
	public SqlSessionFactory factory(BasicDataSource source) throws Exception {
		SqlSessionFactoryBean factoryBean=new SqlSessionFactoryBean();
		factoryBean.setDataSource(source);
		SqlSessionFactory factory=factoryBean.getObject();
		return factory;
		
	}
	
	// SqlSessionTemplate 등록
    @Bean
    public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
    
  //react CORS 설정
  	@Override
      public void addCorsMappings(CorsRegistry registry) {
          registry.addMapping("/**") // 모든 경로에 대해
              .allowedOrigins("http://localhost:5173") // 허용할 출처
              .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // 허용할 메소드
              .allowedHeaders("*") // 허용할 헤더
              .allowCredentials(true); // 쿠키와 인증 정보를 허용할지 여부
      }
	
	@Bean
	   public MapperFactoryBean<BoardMapper> boardMapper(SqlSessionFactory factory) throws Exception{
	      MapperFactoryBean<BoardMapper> factoryBean = new MapperFactoryBean<BoardMapper>(BoardMapper.class);
	      factoryBean.setSqlSessionFactory(factory);
	      return factoryBean;
	   }
	
	@Bean
	   public MapperFactoryBean<ProfileMapper> profileMapper(SqlSessionFactory factory) throws Exception{
	      MapperFactoryBean<ProfileMapper> factoryBean = new MapperFactoryBean<ProfileMapper>(ProfileMapper.class);
	      factoryBean.setSqlSessionFactory(factory);
	      return factoryBean;
	   }
	
	@Bean
	   public MapperFactoryBean<UserMapper> userMapper(SqlSessionFactory factory) throws Exception{
	      MapperFactoryBean<UserMapper> factoryBean = new MapperFactoryBean<UserMapper>(UserMapper.class);
	      factoryBean.setSqlSessionFactory(factory);
	      return factoryBean;
	   }
	
	@Bean
	   public MapperFactoryBean<PortfolioMapper> portfolioMapper(SqlSessionFactory factory) throws Exception{
	      MapperFactoryBean<PortfolioMapper> factoryBean = new MapperFactoryBean<PortfolioMapper>(PortfolioMapper.class);
	      factoryBean.setSqlSessionFactory(factory);
	      return factoryBean;
	   }
	
	@Bean
	   public MapperFactoryBean<StockDataMapper> stockDataMapper(SqlSessionFactory factory) throws Exception{
	      MapperFactoryBean<StockDataMapper> factoryBean = new MapperFactoryBean<StockDataMapper>(StockDataMapper.class);
	      factoryBean.setSqlSessionFactory(factory);
	      return factoryBean;
	   }
	
	@Bean
	   public MapperFactoryBean<FavoriteMapper> favoriteMapper(SqlSessionFactory factory) throws Exception{
	      MapperFactoryBean<FavoriteMapper> factoryBean = new MapperFactoryBean<FavoriteMapper>(FavoriteMapper.class);
	      factoryBean.setSqlSessionFactory(factory);
	      return factoryBean;
	   }
	
	@Bean
	public MapperFactoryBean<CommentMapper> commentMapper(SqlSessionFactory factory) throws Exception {
		MapperFactoryBean<CommentMapper> factoryBean = new MapperFactoryBean<CommentMapper>(CommentMapper.class);
		factoryBean.setSqlSessionFactory(factory);
		return factoryBean;
	}
	
	
	@Bean
	   public ReloadableResourceBundleMessageSource messageSource() {
	      ReloadableResourceBundleMessageSource res = new ReloadableResourceBundleMessageSource();
	      res.setBasenames("/WEB-INF/properties/error_message");
	      return res;
	   }
	
	@Override
	   public void addInterceptors(InterceptorRegistry registry) {

	      WebMvcConfigurer.super.addInterceptors(registry);

	      TopMenuInterceptor topMenuInterceptor = new TopMenuInterceptor(loginUserBean, profileBean);

	      InterceptorRegistration reg1 = registry.addInterceptor(topMenuInterceptor);
	      reg1.addPathPatterns("/**"); // 
	      
	      CheckLoginInterceptor checkLoginInterceptor = new CheckLoginInterceptor(loginUserBean);
	      InterceptorRegistration reg2 = registry.addInterceptor(checkLoginInterceptor);
	      reg2.addPathPatterns("/portfolio/**","/user/myPage","user/changePassword", "user/deleteMember");
	      reg2.excludePathPatterns("/portfolio/loginError");  // 로그인 오류 페이지는 예외처리
	      //reg2.excludePathPatterns("/board/main");
	}
	
	//소스와 메세지를 별도로 관리
	@Bean
	   public static PropertySourcesPlaceholderConfigurer PropertySourcesPlaceholderConfigurer() {
	      return new PropertySourcesPlaceholderConfigurer();
	   }
	
	//enctype="multipart/form-data"의 정보를 받기위해 사용
	   @Bean
	   public StandardServletMultipartResolver multipartResolver() {
	      return new StandardServletMultipartResolver(); // 객체 생성하여 반환
	   }

	
	
	
	
	

	
	
	
	

}
