from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
import time
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
from pprint import pprint
import csv

PATH = "./chromedriver"
options = Options()
options.add_argument("--remote-debugging-port=9222")

f = open("cars.csv", "a")
writer = csv.writer(f)
header = ["car_brand","ad_price","ad_title","ad_source","ad_url","car_color","car_model","reservoir","image"]
writer.writerow(header)

browser = webdriver.Chrome(PATH, options=options)

browser.get("https://www.promoneuve.fr/resultats?marque=&origin=PAGING")

print("Website title: ", browser.title)

for j in range(1,622):

    element = WebDriverWait(browser, 7).until(
        EC.presence_of_element_located(
            (By.LINK_TEXT,str(j))
        )
    )
    element = browser.find_element_by_link_text(str(j))
    element.click()
    print("page "+str(j))
    with open("page","w") as f:
        f.write(str(j))
    for i in range(1, 21):
        car = []
        try:
            element = WebDriverWait(browser, 7).until(
                EC.presence_of_element_located(
                    (By.CSS_SELECTOR,
                     f"#container-body > div > div.clearfix.padding-bottom.margin-top > section > div.row-fluid.col-lg-12.col-md-12.col-sm-12.no-padding.border-grey-top > div:nth-child({i}) > div:nth-child(2) > div.col-lg-4.col-md-5.col-sm-5.col-xs-5.no-padding > div > div:nth-child(2) > a > img"))
            )
            element.click()

            title = browser.find_element_by_css_selector("#container-body > div > div.container-fluid > section.col-lg-9.col-md-12.col-sm-12.col-xs-12.clearfix.no-margin.margin-top30.no-margin-top-xs.pull-left.no-padding-xs.pull-left.z-index3-xs > div > div.width65-lg.width61-5-sm.col-xs-12.pull-left.no-margin.margin-bottom.relative.no-padding.padding-right.no-padding-xs.margin-top-xs > h1")
            color = browser.find_element_by_css_selector("#container-body > div > div.container-fluid > section.col-lg-9.col-md-12.col-sm-12.col-xs-12.clearfix.no-margin.margin-top30.no-margin-top-xs.pull-left.no-padding-xs.pull-left.z-index3-xs > div > div.width65-lg.width61-5-sm.col-xs-12.pull-left.no-margin.margin-bottom.relative.no-padding.padding-right.no-padding-xs.margin-top-xs > h1 > span:nth-child(2)")
            price = browser.find_element_by_css_selector("#title-detail-page > div > div.col-lg-8.col-md-8.col-sm-8.col-xs-9.no-padding-right > span")
            reservoir = browser.find_element_by_css_selector("#container-global.row-fluid.margin-top50-xs.bg-simple-white div.container-site div#container-body.clearfix div.no-padding div.container-fluid section.col-lg-9.col-md-12.col-sm-12.col-xs-12.clearfix.no-margin.no-padding-xs div.row.clearfix.no-margin div.row.clearfix.no-margin div.clearfix.relative div.row.no-margin div.col-lg-6.col-md-6.col-sm-6.clearfix.no-padding-right.no-padding-left-xs div.clearfix.size14 div.margin-bottom.text-dark-grey span.text-lighter-black")
            image = browser.find_element_by_css_selector("img.no-padding")

            car.append(title.text.split(" ")[0])
            car.append(price.text)
            car.append(title.text)
            car.append(browser.title)
            car.append(browser.current_url)
            car.append(color.text)
            car.append(title.text.split(" ")[1])
            car.append(reservoir.text)
            car.append(image.get_attribute("src"))

            writer.writerow(car)

            # print(f"car {i}: " ,end="")
            # pprint(car)

            browser.back()


        except KeyboardInterrupt:
            print("interrupted !")
            browser.quit()
            f.close()
            exit()
        except Exception as e:
            print(e)
            continue
f.close()