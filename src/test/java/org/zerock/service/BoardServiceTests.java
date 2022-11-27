 package org.zerock.service;

import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.dowell.board.service.BoardService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
//@ContextConfiguration(classes= {RootConfig.class})
@Log4j
public class BoardServiceTests {

	@Setter(onMethod_ = {@Autowired})
	private BoardService service;

//	@Test
//	public void testExist() {
//
//		log.info(service);
//		assertNotNull(service);
//
//	}

//	//글 등록
//	@Test
//	public void testRegister() {
//
//		BoardVO board = new BoardVO();
//		board.setTitle("새로작성하는 글");
//		board.setContent("새로작성!");
//		board.setWriter("새로운");
//
//		service.register(board);
//
//		log.info("새로 생성된 게시물 번호..."+ board.getBno());
//	}

//	@Test
//	public void testGetList() {
//
////		service.getList().forEach(board -> log.info(board));
//		service.getList(new Criteria(2, 10)).forEach(board->log.info(board));
//
//	}

//	@Test
//	public void testGet() {
//		log.info(service.get(1L));
//	}

//	@Test
//	public void testDelete() {
//		log.info("remove result : "+ service.remove(41L));
//	}

//	//수정
//	@Test
//	public void testUpdate() {
//
//		BoardVO board = service.get(22L);
//
//		if(board==null) {
//			return ;
//		}
//
//		board.setTitle("제목수정22");
//
//		log.info("수정할거야: "+ service.modify(board));
//
//	}



}












