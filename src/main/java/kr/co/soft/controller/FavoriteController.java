package kr.co.soft.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.soft.beans.FavoriteBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.FavoriteService;


@RestController
public class FavoriteController {

  @Autowired
  private FavoriteService favoriteService;


  @Resource(name = "loginUserBean")
  private UserBean loginUserBean;

//POST 방식으로 /favorite 경로에 요청이 들어올 때 실행됨
 @PostMapping("/favorite")
 public void insertFavorite(@RequestParam("symbol") String symbol, @RequestParam("type") String type) {
	 

   int member_idx = loginUserBean.getMember_idx();

   FavoriteBean favoriteBean = new FavoriteBean();
   favoriteBean.setMember_idx(member_idx);
   favoriteBean.setSymbol(symbol);
   favoriteBean.setType(type);
   // 타입에 따라 다른 처리를 할 수 있습니다.
   favoriteService.insertFavorite(favoriteBean);
 }

 @PostMapping("/favorite/delete")
 public String deleteFavorite(@RequestParam("symbol") String symbol, @RequestParam("type") String type) {
	 
	 
	 int member_idx=loginUserBean.getMember_idx();
   try {
     // 즐겨찾기 삭제 로직 호출
     favoriteService.deleteFavorite(symbol,member_idx);
     return "즐겨찾기가 성공적으로 삭제되었습니다.";
   } catch (Exception e) {
     return "오류가 발생했습니다. 즐겨찾기를 삭제할 수 없습니다.";
   }
 }
 
 // POST 방식으로 /favorite/select 요청 시 즐겨찾기 목록 반환 (JSON)
 @PostMapping("/favorite/select")
 public List<FavoriteBean> selectFavorite() {
   int member_idx = loginUserBean.getMember_idx();
   List<FavoriteBean> favorites = favoriteService.selectFavoritesByMemberIdx(member_idx);
   return favorites;
 }


}
