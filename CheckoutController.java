package com.ikala.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/checkout")
public class CheckoutController {

    // 用於模擬 Memory Leak 的靜態清單 (GC 無法回收)
    private static final List<byte[]> leakyList = new ArrayList<>();

    // 情境一：正常 API (對照組)
    @GetMapping("/fast")
    public String fastCheckout() {
        return "Checkout completed seamlessly in 50ms!";
    }

    // 情境二：API 延遲瓶頸 (餵給 Cloud Trace)
    @GetMapping("/slow")
    public String slowCheckout() throws InterruptedException {
        // 模擬呼叫第三方物流 API 卡住 3 秒
        Thread.sleep(3000); 
        return "Checkout delayed! Took 3000ms to response.";
    }

    // 情境三：Memory Leak 記憶體洩漏 (餵給 Cloud Profiler)
    @GetMapping("/leak")
    public String memoryLeak() {
        // 每次呼叫就配置 10MB 的無用記憶體，並保持參照不讓其釋放
        byte[] junk = new byte[10 * 1024 * 1024];
        leakyList.add(junk);
        return "Leaked 10MB. Total leaked items in heap: " + leakyList.size();
    }
}
