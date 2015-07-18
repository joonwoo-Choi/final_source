package com.sw.utils.book
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BookMove extends Sprite
	{
		public var book:Book;
		public var pages:MovieClip;
		
		public var pw:Number;
		public var ph:Number;
		public var imgTotal:int;
		public var maxpage:int;
		public var clickarea:int;
		public var afa:int;
		public var hcover:Boolean;
		public var page:int;
		public var basePage:int;
		
		public var gs:int = 4;
		public var ps:int = 4;
		public var es:int = 4;
		
		public var pFlag:Boolean = true;
		public var canflip:Boolean = true;
		public var zoomFlag:Boolean = false;
		public var slideFlag:Boolean = false;
		public var GoFlag:Boolean = false;
		
		// 변수의 초기 설정 
		public var btnFlag:Boolean = true;
		public var mcnt:int = 0;
		public var gpage:Number = 0;
		public var gflip:Boolean = false;
		public var gdir:Number = 0;
		public var gskip:Boolean = false;
		public var gtarget:Number = 0;
		public var aflip:Boolean = false;
		public var flip:Boolean = false;
		public var flipOff:Boolean = false;
		public var flipOK:Boolean = false;
		public var hflip:Boolean = false;
		public var rotz:Number = -30;
		public var preflip:Boolean = false;
		public var ctear:Boolean = false;
		public var tear:Boolean = false;
		public var teard:Number = 0;
		public var tlimit:Number = 80;
		public var mpx:Number =100; 
		public var mpy:Number=100;
		public var sx:Number = 0;
		public var sy:Number=0;
		public var numX:Number = 0;
		public var numY:Number = 0;
		public var ax:Number = 0;
		public var ay:Number = 0;
		public var acnt:Number = 0;
		public var aadd:Number = 0;
		public var aamp:Number = 0;
		public var AM:Number = Math.PI/180;
		public var tox:Number;
		public var toy:Number;
		public var ox:Number;
		public var oy:Number;
		public var r0:Number;
		public var r1:Number;
		public var offs:Number;
		public var pageN:MovieClip;
		public var pageO:MovieClip;
		
		public var pageNumber:Array;
		public var removedPages:Array = new Array();
		
		//생성자
		public function BookMove($book:Book)
		{
			book = $book;
			
			pw = (book.pw) ? (book.pw) : (467);
			ph = (book.ph) ? (book.ph) : (588);
			maxpage = imgTotal = book.TotalPages;
			hcover = book.cover;
			
			page = (hcover) ? (0) : (1);	
			basePage = page;
			clickarea = 80;
			afa = 150;
			
			pages = book.pages;
			
			this.addEventListener(Event.ENTER_FRAME,oef);
		}
		
		//페이지들의 초기화 높이 넓이 좌표등... (초기에 한번 호출)
		public function reset():void
		{
			pages.p0.page.x = -pw;
			pages.p0.x = 0;
			pages.p1.page.x = -pw;
			pages.p1.x = 0;
			pages.flip.p2.page.x = -pw;
			pages.flip.p2.x = pw;
			pages.flip.p3.page.x = -pw;
			pages.flip.p3.x = 0;
			pages.p4.page.x = -pw;
			pages.p4.x = pw;
			
			pages.pgrad.visible = 
				pages.mask_mc.visible = 
				pages.flip.visible = false;
			
			pages.pgmask.width = pw*2;
			pages.pgmask.height = ph;
			
			pages.flip.fmask.page.pf.width = pw;
			pages.flip.fmask.page.pf.height = ph;
			pages.pgrad.height =
				pages.mask_mc.height = 2*Math.sqrt(ph*ph+pw*pw);
			pageNumber = new Array();
			for (var i:int=0; i<=(maxpage); i++) pageNumber[i] = i;	
		}
		
		//hflip에 리턴한다.  hcover가 true 면 true를 리턴해서 hflip에 저장
		public function checkCover($p:Number,$dir:Number):Boolean
		{
			if(hcover) return true;
			return false;
		}
		public function corner():Boolean
		{
			return false;
			var numX:Number = Math.abs(pages.mouseX);
			var numY:Number = Math.abs(pages.mouseY);
			
			if(numX>(pw-afa) && numX<pw && numY>(ph/2-afa) && 
				numY<(ph/2) && slideFlag==false) return true;
			
			return false;
		}
		
		//enterframe - 루프 도는 함수
		public function oef(e:Event):void 
		{
			if (zoomFlag == false) 
			{
				if (!flip && corner()) 
				{
					preflip = true;
					if (!autoflip()) preflip = false;
				}
				if (preflip && !corner()) 
				{
					preflip = false;
					flip = false;
					flipOK = false;
					flipOff = true;
				}
				
				getm();
				if (aflip && !preflip) 
				{
					numY = (ay += (sy-ay)/(gflip ? gs : ps));
					acnt += aadd;
					ax -= aadd;
					if (Math.abs(acnt)>pw) 
					{
						flipOK = true;	flipOff = true;
						flip = false;	aflip = false;
					}
				}
				if (flip) 
				{
					if (tear) 
					{
						numX = tox;
						numY = (toy += teard);
						teard *= 1.2;
						if (Math.abs(teard)>1200) 
						{	flipOff = true;	flip = false;	}
					} 
					else 
					{
						numX = (ox += (numX-ox)/(gflip ? gs : ps));
						numY = (oy += (numY-oy)/(gflip ? gs : ps));
					}
					
					calc(numX, numY);
				}
				if (flipOff) 
				{
					if (flipOK || tear) 
					{
						numX = (ox += (-sx-ox)/(gflip ? gs : es));
						numY = (oy += (sy-oy)/(gflip ? gs : es));
						
						calc(numX,numY);
						
						if (numX/-sx>0.99 || tear) 
						{
							flip = false;
							
							flipOK = flipOff = false;
							pages.pgrad.visible = 
								pages.flip.visible = false;
							
							if(tear) 
							{
								removePage((sx<0) ? page : page+1);
								page += (sx<0) ? -2 : 0;
							}
							else page += (sx<0) ? -2 : 2;
							
							if(gskip) page = gtarget;
							
							setPages(page, 0, 0, page+1);
							tear = false;
							if (gpage>0 && !gskip) 
							{	gpage--;	autoflip();	} 
							else
							{ 	gflip = gskip = false;	}
							btnFlag = true;
							
							if(GoFlag) GoFlag = false;
						}
						else btnFlag = false;
					} 
					else 
					{
						numX = (ox += (sx-ox)/3);
						numY = (oy += (sy-oy)/3);
						
						calc(numX, numY);
						
						if (numX/sx>0.99) 
						{
							flip = false;
							flipOff = false;
							aflip = false;
							pages.pgrad.visible = pages.flip.visible=false;
							setPages(page, 0, 0, page+1);
						}
					}
				}
			}
		}
		
		//페이지들의 모션을 
		public function calc($numX:Number,$numY:Number):void 
		{
			if (hflip) 
			{
				//hardflip...
				pages.flip.mask = null;
				pages.flip.visible = true;
				pages.flip.fgrad.visible = false;
				pages.flip.p2.visible = pages.flip.p3.visible = false;
				return;
			} 
			else pages.flip.fgrad.visible = true;
			
			var rr0:Number = Math.sqrt(($numY+ph/2)*($numY+ph/2)+$numX*$numX);
			var rr1:Number = Math.sqrt((ph/2-$numY)*(ph/2-$numY)+$numX*$numX);
			var a:Number;
			
			if ((rr0 > r0 || rr1>r1) && !tear) 
			{
				if ($numY < sy) 
				{
					a = Math.asin((ph/2-$numY)/rr1);
					$numY = (ph/2-Math.sin(a)*r1);
					$numX = ($numX<0) ? -Math.cos(a)*r1 : Math.cos(a)*r1;
					if ($numY > sy) 
					{
						if (( sx*$numX)>0){ $numY=sy; $numX=sx;	}
						else { $numY=sy; $numX=-sx;	}
					}
					if ((rr1-r1)>tlimit && ctear) 
					{
						teard = -5;
						tear = true;
						tox = ox= $numX;
						toy = oy= $numY;
					}
				} 
				else 
				{
					a = Math.asin(($numY+ph/2)/rr0);
					$numY = Math.sin(a)*r0-ph/2;
					$numX = ($numX<0) ? -Math.cos(a)*r0 : Math.cos(a)*r0;
					if ($numY<sy) 
					{
						if ((sx*$numX)>0) 
						{	$numY=sy; $numX=sx;	}
						else { $numY=sy; $numX=-sx;	}
					}
					if ((rr0-r0)>tlimit && ctear) 
					{
						teard = 5;
						tear = true;
						tox = ox = $numX;
						toy = oy = $numY;
					}
				}
			}
			if ((sx<0 && ($numX-sx)<10) || (sx>0 && (sx-$numX)<10)) 
			{
				if (sx<0) $numX = -pw+10;
				if (sx>0) $numX = pw-10;
			}
			
			pages.flip.visible = true;
			pages.pgrad.visible = !tear;
			pages.flip.p2.visible = 
				pages.flip.p3.visible = true;
			
			var vx:Number = $numX-sx;
			var vy:Number = $numY-sy;
			var a1:Number = vy/vx;
			var a2:Number = -vy/vx;
			var cx:Number = sx+(vx/2);
			var cy:Number = sy+(vy/2);
			
			var r:Number = Math.sqrt((sx-$numX)*(sx-$numX)+(sy-$numY)*(sy-$numY));
			a = Math.asin((sy-$numY)/r);
			if (sx<0) a = -a;
			
			var ad:Number = a/AM;
			pageN.rotation = ad*2;
			r = Math.sqrt((sx-$numX)*(sx-$numX)+(sy-$numY)*(sy-$numY));
			var rl:Number = (pw*2);
			var nx:Number;
			var ny:Number;
			if (sx>0) 
			{
				//flip forward
				pages.mask_mc.scaleX = 1;
				nx = cx-Math.tan(a)*(ph/2-cy);
				ny = ph/2;
				if (nx>pw) 
				{
					nx = pw;
					ny = cy+Math.tan(Math.PI/2+a)*(pw-cx);
				}
				pageN.pf.x = -(pw-nx);
				
				pages.flip.fgrad.scaleX = ((r/rl/2)*pw)/100;
				pages.pgrad.scaleX = -((r/rl/2)*pw)/100;
			}
			else
			{
				//flip backward
				pages.mask_mc.scaleX = -1;
				nx = cx-Math.tan(a)*(ph/2-cy);
				ny = ph/2;
				if (nx<-pw) 
				{
					nx = -pw;
					ny = cy+Math.tan(Math.PI/2+a)*(-pw-cx);
				}
				pageN.pf.x = -(pw-(pw+nx));
				
				pages.flip.fgrad.scaleX = -((r/rl/2)*pw)/100;
				pages.pgrad.scaleX = ((r/rl/2)*pw)/100;
			}
			
			pages.mask_mc.x = cx;
			pages.mask_mc.y = cy;
			pages.mask_mc.rotation = ad;
			pageN.pf.y = -ny;
			pageN.x = nx+offs;
			pageN.y = ny;
			pages.flip.fgrad.x = cx;
			pages.flip.fgrad.y = cy;
			pages.flip.fgrad.rotation = ad;
			pages.flip.fgrad.alpha = (r>(rl-50)) ? (100-(r-(rl-50))*2)/100 : 1;
			
			pages.pgrad.x = cx;
			pages.pgrad.y = cy;
			pages.pgrad.rotation = ad+180;
			pages.pgrad.alpha = (r>(rl-100)) ? (100-(r-(rl-100)))/100 : 1;
			pages.flip.fmask.page.x = pageN.x;
			pages.flip.fmask.page.y = pageN.y;
			pages.flip.fmask.page.pf.x = pageN.pf.x;
			pages.flip.fmask.page.pf.y = pageN.pf.y;
			pages.flip.fmask.page.rotation = pageN.rotation;
		}
		//커버 페이지에 스케일 및 왜곡을 주는 함수
		public function scalc($obj:Object, $numX:Number):void
		{
			if ($numX < -pw) $numX = -pw;
			if ($numX > pw) $numX = pw;
			var a:Number = Math.asin($numX/pw);
			var rot:Number = a/AM/2;
			var xs:Number = 100;
			var ss:Number = 100*Math.sin(rotz*AM);
			$numX = $numX/2;
			var numY:Number = Math.cos(a)*(pw/2)*(ss/100);
			placeImg($obj, rot, ss, $numX, numY);
			
			pages.pgrad.visible = pages.flip.visible = true;
			pages.pgrad.scaleX = $numX/100;
			pages.pgrad.alpha = 1;
			
			pages.pgrad.x = 0;
			pages.pgrad.y = 0;
			pages.pgrad.rotation = 0;
		}
		//커버 페이지에 스케일 및 왜곡을 주는 함수
		public function placeImg($obj:Object,$rot:Number,$ss:Number,$numX:Number,$numY:Number):void 
		{
			var flag:Number;
			if ($numX<0) flag = -1;
			else flag = 1;
			
			var m:Number = Math.tan($rot*AM);
			var f:Number = Math.SQRT2/Math.sqrt(m*m+1);
			var phxs:Number = 100*m;
			var phRot:Number = -$rot;
			var xs:Number = 100*f;
			var ys:Number = 100*f;
			
			$obj.ph.pic.scaleX = (phxs<0) ? -xs/100 : xs/100;
			$obj.ph.scaleX = phxs/100;
			
			$obj.x = $obj.width/2*flag;
			$obj.visible = true;
		}
		
		//해당 페이지들을 attach 시키는 함수.
		public function setPages($p1:Number,$p2:Number,$p3:Number,$p4:Number):void
		{
			var p0:Number = $p1-2;
			var p5:Number = $p4+2;
			if (p0<0) p0 = 0;
			if (p5>maxpage) p5 = 0;
			if ($p1<0) $p1 = 0;
			if ($p2<0) $p2 = 0;
			if ($p3<0) $p3 = 0;
			if ($p4<0) $p4 = 0;
			
			Chage(pages.p1.page.pf.ph,$p1);
			pages.p1.page.pf.ph.y = -ph/2;
			Chage(pages.p0.page.pf.ph,p0);
			pages.p0.page.pf.ph.y = -ph/2;
			if(!hflip)
			{	
				Chage(pages.flip.p2.page.pf.ph,$p2);
				pages.flip.p2.page.pf.ph.y = -ph/2;
				Chage(pages.flip.p3.page.pf.ph,$p3);
				pages.flip.p3.page.pf.ph.y = -ph/2;
			}
			Chage(pages.p4.page.pf.ph,$p4);
			pages.p4.page.pf.ph.y = -ph/2;
			//trace(p0+","+$p1+","+$p2+","+$p3+","+$p4+","+p5);
		}
		
		// 해당 페이지를 attach 하는 함수 (우선 초기에 한번 호출됨)
		public function resetPages():void 
		{
			setPages(page, 0, 0, page+1);
		}
		public function autoflip():Boolean
		{
			if (!aflip && !flip && !flipOff && canflip) 
			{
				acnt = 0;
				aamp = Math.random()*(ph/2)-(ph/4);
				var numX:Number = gflip ? (gdir*pw)/2 : ((pages.mouseX<0) ? -pw/2 : pw/2);
				
				var numY:Number = Math.random()*(ph/2)-(ph/4);
				var pmh:Number = ph/2;
				var r:Number = Math.sqrt(numX*numX+numY*numY);
				var a:Number = Math.asin(numY/r);
				var yy:Number = Math.tan(a)*pw;
				
				if (numY>0 && numY>ph/2) numY = ph/2;
				if (numY<0 && numY<-ph/2) numY = -ph/2;
				
				oy = sy = yy;
				ax = (pages.mouseX<0) ? -pw/2 : pw/2;
				var l:Number = ((ph/2)-numY);
				ay = numY+((Math.random()*2*l)-l)/2;
				
				offs = -pw;
				var hit:int = 0;
				
				if (numX<0 && page>0) 
				{
					//trace("prev");
					pages.flip.p3.x = 0;
					hflip = false;
					if (!(preflip && hflip)) 
					{
						if (gskip) setPages(gtarget, gtarget+1, page, page+1);
						else setPages(page-2, page-1, page, page+1);
					}
					hit = -1;
				}
				if (numX>0 && page<maxpage) 
				{
					//trace("next");
					pages.flip.p3.x = pw;
					hflip = false;
					if (!(preflip && hflip)) 
					{
						if (gskip) setPages(page, gtarget, page+1, gtarget+1);
						else setPages(page, page+2, page+1, page+3);
					}
					hit = 1;
				}
				if (hflip && preflip) 
				{
					hit = 0;
					preflip = false;
					return false;
				}
				if (hit) 
				{
					flip = true;
					flipOff = false;
					ox = sx=hit*pw;
					pages.flip.mask = pages.mask_mc;
					aadd = hit*(pw/(gflip ? 5 : 10));
					aflip = true;
					pages.flip.fmask.x = pw;
					
					if (preflip) oy = sy=(pages.mouseY<0) ? -(ph/2) : (ph/2);
					
					r0 = Math.sqrt((sy+ph/2)*(sy+ph/2)+pw*pw);
					r1 = Math.sqrt((ph/2-sy)*(ph/2-sy)+pw*pw);
					pageN = pages.flip.p2.page;
					pageO = pages.flip.p3;
					
					oef(new Event(Event.ENTER_FRAME));
					return true;
				}
			} 
			return false;
		}
		
		public function getm():void 
		{
			if (aflip && !preflip) 
			{
				numX = ax;
				numY = ay;
			} 
			else 
			{
				numX = pages.mouseX;
				numY = pages.mouseY;
			}
		}
		public function gotoPage(i:int, $skip:Boolean=false):Boolean
		{
			if (zoomFlag == false) 
			{
				i = getPN(i);
				gskip = $skip;
				
				if (i<0) return false;
				var p:int = int(page/2);
				var d:int = int(i/2);
				
				if (p != d && canflip && !gflip) 
				{
					if (p<d) 
					{	gdir = 1;	gpage = d-p-1;	} 
					else 
					{	gdir = -1;	gpage = p-d-1;	}
					gflip = true;
					if (gskip){ gtarget =d*2; gpage=0;	}
					autoflip();
				} 
				else gskip = false;
			}
			return true;
		}
		
		public function getPN(i:int):int
		{
			var bFind:Boolean = false;
			for (var j:int =1; j<=maxpage; j++) 
			{
				if (i == pageNumber[j]) 
				{
					i = j;
					bFind = true;
					break;
				}
			}
			if (bFind) return i;
			else return -1;
		}
		public function removePage(i:Number):void 
		{
			i = (Math.floor((i-1)/2)*2)+1;
			removedPages.push(pageNumber[i], pageNumber[i+1]);
			for (var j:int=(i+2); j<=(maxpage+1); j++) 
				pageNumber[j-2] = pageNumber[j];
			
			maxpage -= 2;
		}
		
		public function Chage($scene:MovieClip,$page:int):void
		{
			var sp:Sprite = $scene.getChildByName("page"+$page) as Sprite;
			var oldSp:Sprite = $scene.getChildByName("page"+$scene.oldPage) as Sprite;
			
			if ($scene.oldPage != $page)
			{
				if(sp)
				{	
					sp.visible = true;	
					sp.x = 0;	
					$scene.addChild(sp);
				}
				if(oldSp && sp)
				{
					$scene.swapChildren(sp,oldSp);			
					oldSp.visible = false;
					oldSp.x = -3000;
				}
				$scene.oldPage = $page;
				
				//if(sp) trace("sp:"+sp.name);
				//if(oldSp) trace("oldSp:"+oldSp.name); 
			}
			if($page == 0) $scene.visible = false;
			else $scene.visible = true;
			
		}
	}
}