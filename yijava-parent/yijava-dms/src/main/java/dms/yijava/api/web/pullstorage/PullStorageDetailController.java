package dms.yijava.api.web.pullstorage;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.Data;
import lombok.NoArgsConstructor;
import dms.yijava.entity.product.Product;

@Controller
@RequestMapping("/api/pullstoragedetail")
public class PullStorageDetailController {
	//同一个仓库下的，同一个批次 不能重复添加
}
